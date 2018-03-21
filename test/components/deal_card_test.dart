import 'package:discount_machine/components/deal_card.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show createHttpClient;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http;

void main() {
  setUpAll(() {
    createHttpClient = createMockImageHttpClient;
  });
  Deal deal;

  setUp(() {
    deal = new Deal();
    deal.url = "http://my.deal.com/super/mega/deal";
    deal.title = "My Deal";
    deal.imageUrl = "https://picsum.photos/500";
    deal.price = 10.0;
    deal.regularPrice = 20.0;
    deal.merchant = "MyStore";
    deal.timestamp = new DateTime.now().millisecondsSinceEpoch;
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
}

// Returns a mock HTTP client that responds with an image to all requests.
ValueGetter<http.Client> createMockImageHttpClient = () {
  return new http.MockClient((http.BaseRequest request) {
    return new Future<http.Response>.value(
        new http.Response.bytes(_transparentImage, 200, request: request));
  });
};

const List<int> _transparentImage = const <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
