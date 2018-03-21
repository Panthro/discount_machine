import 'package:timeago/timeago.dart';

class Deal {
  String title;

  String imageUrl;

  double price;

  String merchant;

  int timestamp;

  double regularPrice;

  String url;

  int likes;

  String get timeAgo => defaultTimeAgo.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));

  int get discountPercentage => ((1 - (price / regularPrice)) * 100).floor();

  String get discountPercentageString => "$discountPercentage%";
}
