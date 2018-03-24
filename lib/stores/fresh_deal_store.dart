import 'dart:async';

import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/stores/deal_store.dart';
import 'package:discount_machine/stores/logging_store.dart';

class FreshDealStore extends LoggingStore {
  static const PAGE_SIZE = 10;

  var dealsReference = DealStore.dealService.databaseReference;

  List<Deal> freshDeals = [];

  Deal get newest => freshDeals.isNotEmpty ? freshDeals.first : null;

  Deal get oldest => freshDeals.isNotEmpty ? freshDeals.last : null;

  sortDeals() {
    freshDeals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

//
//  refresh() {
//    logger.fine('Initializing Store');
//    dealsReference.limitToLast(PAGE_SIZE).onChildAdded.listen((event) {
//      var deal = new Deal()..updateFromSnapshot(event.snapshot);
//      _addDeal(deal);
//    });
//  }

  loadMore({refresh: false}) async {
    logger.fine('Loading more');
    var added = 0;
    StreamSubscription subscription;
    var query = dealsReference.orderByKey().limitToLast(PAGE_SIZE);
    if (freshDeals.isNotEmpty && !refresh) {
      logger.fine('Using oldest deal $oldest');
      query = query.endAt(oldest?.key);
    }

    subscription = query.onChildAdded.listen((event) {
      if (added >= PAGE_SIZE) {
        subscription.cancel();
      }
      _addDeal(new Deal()..updateFromSnapshot(event.snapshot));
    });
  }

  clear() async {
    this.freshDeals.clear();
    logger.fine('Deal store cleared');
    trigger();
  }

  void _addDeal(Deal deal) {
    logger.finest('_addDeal $deal');
    if (!_isLoaded(deal)) {
      freshDeals.add(deal);
      sortDeals();
      trigger();
    }
  }

  _isLoaded(Deal deal) {
    return freshDeals.map((deal) => deal.key).contains(deal.key);
  }
}
