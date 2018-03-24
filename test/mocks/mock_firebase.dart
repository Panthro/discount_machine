import 'package:discount_machine/services/deal_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mockito/mockito.dart';

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDealService extends Mock implements DealService {
  DatabaseReference mockDatabaseReference = new MockDatabaseReference();

  @override
  DatabaseReference get databaseReference => mockDatabaseReference;
}

class MockEvent extends Mock implements Event {}

class MockQuery extends Mock implements Query {}
