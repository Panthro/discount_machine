import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/stores/logging_store.dart';
import 'package:flutter_flux/flutter_flux.dart';

class DealStore extends LoggingStore {
  static DealStore _instance = new DealStore._private();

  factory DealStore() => _instance;

  static Action<Null> fetchLatestDealsAction = new Action<Null>();
  static Action clearAction = new Action();

  List<Deal> _deals = new List<Deal>();

  DealStore._private() {
    triggerOnAction(fetchLatestDealsAction, _fetchLatestDeals);
    triggerOnAction(clearAction, _clear);
    listen((_) => {});
  }

  List<Deal> get deals => new List<Deal>.unmodifiable(_deals);

  List<Deal> get _dealsCopy => new List<Deal>.from(_deals);

  List<Deal> get latestDeals =>
      new List<Deal>.unmodifiable(_dealsCopy..sort((a, b) => b.timestamp.compareTo(a.timestamp)));

  _fetchLatestDeals(_) {
    var deal = new Deal()
      ..regularPrice = 10.0
      ..price = 10.0
      ..likes = 100
      ..title = "Awesome deal!!!"
      ..url = "http://some.url.com"
      ..timestamp = new DateTime.now().millisecondsSinceEpoch
      ..merchant = "AwesomeMerchant"
      ..imageUrl = "https://placeimg.com/640/480/tech"
      ..regularPrice = 50.0;

    this._deals.add(deal);
  }

  _clear(_) {
    this._deals.clear();
  }
}
