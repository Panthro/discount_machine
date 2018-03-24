import 'dart:async';

import 'package:discount_machine/commons/log.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/services/deal_service.dart';
import 'package:discount_machine/stores/deal_store.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_deal.dart';
import '../mocks/mock_firebase.dart';

void main() {
  DealStore store;
  DealService dealService;
  StreamController<Event> newDealsStreamController;

  var newDealEvent;
  var snapshot;

  addDeal() async {
    snapshot = new MockDataSnapshot();
    when(snapshot.value).thenReturn(newDealMockValues());
    newDealEvent = new MockEvent();
    when(newDealEvent.snapshot).thenReturn(snapshot);
    newDealsStreamController.add(newDealEvent);
    //Giving a chance for the stream to get the new event
    await new Future(() {});
  }

  setUp(() {
    setupLogger(level: Level.ALL);

    dealService = new MockDealService();

    Query latestDealsQuery = new MockQuery();
    newDealsStreamController = new StreamController<Event>.broadcast();
    when(latestDealsQuery.onChildAdded).thenReturn(newDealsStreamController.stream);
    when(dealService.latestDealsQuery).thenReturn(latestDealsQuery);
    DealStore.dealService = dealService;
    store = new DealStore();
  });

  tearDown(() async {
    await store.clear();
    newDealsStreamController.close();
  });

  group("DealStore", () {
    test("should clear store", () async {
      expect(store.orderedDeals, isEmpty);

      await store.fetchLatestDeals();

      await addDeal();

      expect(store.orderedDeals, isNotEmpty);

      await store.clear();

      expect(store.orderedDeals, isEmpty);
    });

    test("should fetch latest deals", () async {
      expect(store.orderedDeals, isEmpty);

      await store.fetchLatestDeals();
      await addDeal();

      expect(store.latestDeals, isNotEmpty);
    });

    test("should order latest deals by timestamp desc", () async {
      expect(new DealStore(), equals(new DealStore()));

      expect(store.orderedDeals, isEmpty);

      await store.fetchLatestDeals();

      await addDeal();

      await new Future.delayed(new Duration(milliseconds: 10));
      await addDeal();

      expect(store.orderedDeals, hasLength(2));

      Deal firstDeal = store.latestDeals[1];
      Deal newestDeal = store.latestDeals[0];

      expect(newestDeal.timestamp, greaterThan(firstDeal.timestamp));
    });
  });
}
