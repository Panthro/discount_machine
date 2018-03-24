import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';

class DealService extends FirebaseCrudService<Deal> {
  DealService() : super('deal');

  //TODO property paging
  Query get latestDealsQuery => databaseReference.limitToLast(2);

  likeDeal(Deal deal) async {
    await increaseMetric(deal, 'like');
  }
}
