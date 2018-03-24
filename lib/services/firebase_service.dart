import 'dart:async';

import 'package:discount_machine/commons/log.dart';
import 'package:discount_machine/model/base_firebase_entity.dart';
import 'package:firebase_database/firebase_database.dart';

/// Firebase config

//abstract class FirebaseUserAwareCrudRepository<T extends BaseFirebaseEntity>
//    extends FirebaseCrudRepository {
//  static Auth auth = new Auth();
//
//  FirebaseUserAwareCrudRepository(String entityName)
//      : super._ref(FirebaseCrudRepository.firebase
//      .reference()
//      .child(auth.user.uid)
//      .child(entityName)
//    ..keepSynced(true));
//}

abstract class FirebaseCrudService<T extends BaseFirebaseEntity> extends LoggerMiddleware {
  static FirebaseDatabase firebase = FirebaseDatabase.instance..setPersistenceEnabled(true);
  final DatabaseReference _databaseReference;

  /// Allow other crud classes to pass their own ref
  FirebaseCrudService._ref(this._databaseReference);

  DatabaseReference get databaseReference => _databaseReference;

  FirebaseCrudService(String entityName)
      : _databaseReference = firebase.reference().child(entityName);

  Future<bool> beforeInsert(T entity) async => true;

  afterInsert(T entity) async {}

  Future<bool> beforeUpdate(T entity) async => true;

  afterUpdate(T entity) async {}

  Future<T> insert(T entity) async {
    assert(entity != null);
    if (await beforeInsert(entity)) {
      if (entity is BaseFirebaseEntity) {
        final newEntityRef = _databaseReference.push();
        await newEntityRef.set(entity.toMap());
        afterInsert(entity);
        entity.updateFromSnapshot(await newEntityRef.once());
      }
    }
    return entity;
  }

  Future<T> update(T entity) async {
    var entityRef = entityReference(entity.key);
    await entityRef.update(entity.toMap());
    entity.updateFromSnapshot(await entityRef.once());
    return entity;
  }

  DatabaseReference entityReference(String key) {
    return _databaseReference.child(key);
  }

  delete(T entity) {
    print('$entity deleted');
    entityReference(entity.key).remove();
  }

  archive(T entity) {
    print('$entity archived');
    entity.archived = true;
    entityReference(entity.key).update(entity.toMap());
  }

  increaseMetric(T entity, String metric) async {
    var ref = entityReference(entity.key);
    await ref.runTransaction((data) {
      if (data != null) {
        if (data.value['metrics'] == null) {
          data.value['metrics'] = new Map<String, dynamic>();
        }
        int newValue = (data.value['metrics'][metric] ?? 0) + 1;
        data.value['metrics'][metric] = newValue;
        logger.finest('$entity $metric increased to $newValue');
      }
    });
  }
}
