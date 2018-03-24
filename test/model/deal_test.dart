import 'package:discount_machine/model/deal.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_deal.dart';
import '../mocks/mock_firebase.dart';

void main() {
  var snapshot;
  var values;
  setUp(() {
    snapshot = new MockDataSnapshot();
    values = newDealMockValues();
  });

  test("Does not crash when price is int", () {
    values['price'] = 10;
    values['regularPrice'] = 10;
    when(snapshot.value).thenReturn(values);

    var deal = new Deal()..updateFromSnapshot(snapshot);

    expect(deal.price, 10);
    expect(deal.regularPrice, 10);
  });

  test("Does not crash when price is null", () {
    values['price'] = null;
    values['regularPrice'] = null;
    when(snapshot.value).thenReturn(values);

    var deal = new Deal()..updateFromSnapshot(snapshot);

    expect(deal.discountPercentage, isNull);
    expect(deal.discountPercentageString, isEmpty);
  });
}
