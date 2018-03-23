import 'dart:async';

import 'package:discount_machine/commons/log.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/stores/deal_store.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  DealStore store;

  setUp(() {
    setupLogger(level: Level.FINE);
    store = new DealStore();
  });

  tearDown(() async {
    await DealStore.clearAction();
  });

  group("DealStore", () {
    test("should clear store", () async {
      expect(store.deals, isEmpty);

      await DealStore.fetchLatestDealsAction();

      expect(store.deals, isNotEmpty);

      await DealStore.clearAction();

      expect(store.deals, isEmpty);
    });

    test("should fetch latest deals", () async {
      expect(store.deals, isEmpty);

      await DealStore.fetchLatestDealsAction();

      expect(store.latestDeals, isNotEmpty);
    });

    test("should order latest deals by timestamp desc", () async {
      expect(new DealStore(), equals(new DealStore()));

      expect(store.deals, isEmpty);

      await DealStore.fetchLatestDealsAction();

      Deal firstDeal = store.latestDeals[0];

      await new Future.delayed(new Duration(milliseconds: 1));

      await DealStore.fetchLatestDealsAction();

      Deal newestDeal = store.latestDeals[0];

      expect(newestDeal.timestamp, greaterThan(firstDeal.timestamp));
    });
  });
}
