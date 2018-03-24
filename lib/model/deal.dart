import 'package:discount_machine/model/base_firebase_entity.dart';
import 'package:timeago/timeago.dart';

class Deal extends BaseFirebaseEntity {
  String get title => getValue('title');

  set title(String title) => setValue('title', title);

  String get imageUrl => getValue('imageUrl');

  set imageUrl(String imageUrl) => setValue('imageUrl', imageUrl);

  num get price => getValue('price');

  set price(num price) => setValue('price', price);

  String get merchant => getValue('merchant');

  set merchant(String merchant) => setValue('merchant', merchant);

  num get regularPrice => getValue('regularPrice');

  set regularPrice(num regularPrice) => setValue('regularPrice', regularPrice);

  String get url => getValue('url');

  set url(String url) => setValue('url', url);

  int get likes => getMetric('likes');

  String get timeAgo => defaultTimeAgo.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));

  int get discountPercentage =>
      price != null && regularPrice != null ? ((1 - (price / regularPrice)) * 100).floor() : null;

  String get discountPercentageString => discountPercentage != null ? "$discountPercentage%" : '';
}
