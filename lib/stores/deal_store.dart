import 'dart:async';
import 'dart:math';

import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/services/deal_service.dart';
import 'package:discount_machine/stores/logging_store.dart';
import 'package:meta/meta.dart';

abstract class DealStore extends LoggingStore {
  static DealService dealService = new DealService();


  List<Deal> get orderedDeals => new List<Deal>.unmodifiable(_deals);

  @protected
  List<Deal> _deals = new List<Deal>();

  List<Deal> get deals => new List<Deal>.unmodifiable(_deals);

  List<Deal> get _dealsCopy => new List<Deal>.from(_deals);

  List<Deal> get latestDeals =>
      new List<Deal>.unmodifiable(_dealsCopy..sort((a, b) => b.timestamp.compareTo(a.timestamp)));

  StreamSubscription latestDealsListener;

  fetchLatestDeals({Deal lastDeal}) async {
    var query = dealService.latestDealsQuery;
    if (lastDeal != null) {
      query.orderByKey().endAt(lastDeal.key);
    }

    if (latestDealsListener != null) {
      latestDealsListener.cancel();
    }

    latestDealsListener = query.onChildAdded.listen((event) {
      var deal = new Deal()
        ..updateFromSnapshot(event.snapshot);
      logger.finest('Latest deal added: $deal');
      _onDealArrived(deal);
      logger.finest('new length: ${_deals.length}');
      trigger();
    });
  }

  clear() async {
    this._deals.clear();
    logger.finest('Deal store cleared');
    trigger();
  }

  _isLoaded(Deal deal) {
    return _deals.map((deal) => deal.key).contains(deal.key);
  }

  _onDealArrived(Deal deal) {
    if (!_isLoaded(deal)) {
      _deals.add(deal);
    } else {
      logger.finest('Deal already loaded');
    }
  }

  addMockDeal() {
    new Timer.periodic(new Duration(milliseconds: 2), (timer) {
      var random = new Random();
      Deal deal = new Deal()
        ..title = "Some amazing deal ${random.nextInt(9999)}"
        ..imageUrl = "https://placeimg.com/640/480/tech?id=${random.nextInt(9999)}"
        ..price = random.nextDouble()
        ..url = "http://some.deal.com"
        ..merchant = "SomeMerchange";

      deal.regularPrice = deal.price * 1.3;

      dealService.insert(deal);
      if (orderedDeals.length >= 3) {
        timer.cancel();
      }
    });
  }
}
