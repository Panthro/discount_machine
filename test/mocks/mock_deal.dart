Map<String, dynamic> newDealMockValues() {
  Map<String, dynamic> mockValues = {};
  mockValues['url'] = "http://my.deal.com/super/mega/deal";
  mockValues['title'] = "My Deal";
  mockValues['imageUrl'] = "https://picsum.photos/500";
  mockValues['price'] = 10.0;
  mockValues['regularPrice'] = 20.0;
  mockValues['merchant'] = "MyStore";
  mockValues['timestamp'] = new DateTime.now().millisecondsSinceEpoch;
  return mockValues;
}
