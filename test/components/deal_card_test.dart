import 'dart:math';

import 'package:discount_machine/components/deal_card.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_deal.dart';
import '../mocks/mock_firebase.dart';
import '../test_utils.dart';

void main() {
  setUpAll(() {
    setupMockImageHttpClient();
  });
  Deal deal;
  DataSnapshot mockDataSnapshot;
  Map<String, dynamic> mockValues;

  setUp(() {
    mockDataSnapshot = new MockDataSnapshot();

    mockValues = newDealMockValues();

    when(mockDataSnapshot.key).thenAnswer((_) => new Random().nextInt(99999).toString());
    when(mockDataSnapshot.value).thenReturn(mockValues);

    deal = new Deal()
      ..updateFromSnapshot(mockDataSnapshot);
  });

  group("Visual elements", () {
    testWidgets('Should show title', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));

      expect(find.text(deal.title), findsOneWidget);
    });

    //TODO test image loading

    testWidgets('Should show merchant', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));

      expect(find.text(deal.merchant), findsOneWidget);
    });

    testWidgets('Should show time ago', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));

      expect(find.text(deal.timeAgo), findsOneWidget);
    });

    testWidgets('Should price row', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));

      String price = deal.price.toString();
      String regularPrice = deal.regularPrice.toString();

      expect(find.text("\$$price"), findsOneWidget);
      expect(find.text("\$$regularPrice"), findsOneWidget);
      expect(find.text(deal.discountPercentageString), findsOneWidget);
    });

    testWidgets('Should have button to view deal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.text('VIEW DEAL');
      expect(finder, findsOneWidget);
    });

    testWidgets('Should show the deal likes', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.text(deal.likes.toString());
      expect(finder, findsOneWidget);
    });

    testWidgets('Should have button to like deal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.byIcon(Icons.thumb_up);
      expect(finder, findsOneWidget);
    });

    testWidgets('Should have button to like deal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.byIcon(Icons.thumb_up);
      expect(finder, findsOneWidget);
    });
    testWidgets('Should have button to comment deal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.byIcon(Icons.comment);
      expect(finder, findsOneWidget);
    });
    testWidgets('Should have button to flag deal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MaterialApp(home: new DealCard(deal)));
      var finder = find.byIcon(Icons.flag);
      expect(finder, findsOneWidget);
    });
  });

  group('Interactions', () {
    testWidgets('Should call onLike when like is pressed', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      var called = false;
      var onLike = (deal) => called = true;

      await tester.pumpWidget(new MaterialApp(
          home: new DealCard(
            deal,
            onLike: onLike,
          )));

      await tester.tap(find.byIcon(Icons.thumb_up));

      expect(called, isTrue);
    });

    testWidgets('Should call onFlag when flag is pressed', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      var called = false;
      var onFlag = (deal) => called = true;

      await tester.pumpWidget(new MaterialApp(
          home: new DealCard(
            deal,
            onFlag: onFlag,
          )));

      await tester.tap(find.byIcon(Icons.flag));

      expect(called, isTrue);
    });

    testWidgets('Should call onComment when flag is pressed', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      var called = false;
      var onComment = (deal) => called = true;

      await tester.pumpWidget(new MaterialApp(
          home: new DealCard(
            deal,
            onComment: onComment,
          )));

      await tester.tap(find.byIcon(Icons.comment));

      expect(called, isTrue);
    });
  });
}
