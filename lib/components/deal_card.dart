import 'package:discount_machine/commons/log.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:flutter/material.dart';

typedef DealActionCallback(Deal deal);

class DealCard extends StatefulWidget {
  final Deal deal;
  final DealActionCallback onLike;
  final DealActionCallback onFlag;
  final DealActionCallback onComment;

  DealCard(this.deal, {this.onLike, this.onFlag, this.onComment});

  @override
  _DealCardState createState() => new _DealCardState(deal);
}

class _DealCardState extends State<DealCard> with LoggerMiddleware {
  final Deal deal;
  var iconColor = Colors.blueGrey;

  _DealCardState(this.deal);

  String get _priceAsString => "\$${deal.price.toString()}";

  String get _regularPriceAsString => "\$${deal.regularPrice.toString()}";

  String get _discountPercentage => deal.discountPercentageString;

  void _callAction(DealActionCallback action) async {
    if (action != null) {
      await action(deal);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            _buildDealImage(),
            new Expanded(
              child: new ListTile(
                dense: true,
                title: new Text(deal.title),
                subtitle: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[_buildMerchantAndTimeRow(), _buildPricingText(context)],
                ),
              ),
            )
          ]),
          _buildButtons(context)
        ],
      ),
    );
  }

  Row _buildMerchantAndTimeRow() {
    return new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[new Text(deal.merchant), new Text(deal.timeAgo)],
    );
  }

  _buildButtons(BuildContext context) {
    var theme = Theme.of(context);
    return new Container(
        child: new ButtonTheme.bar(
          child: new ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildLikeButton(theme),
              new IconButton(
                  icon: new Icon(
                    Icons.comment,
                    color: iconColor,
                  ),
                  onPressed: () async {
                    logger.finest('onComment $deal');
                    _callAction(this.widget.onComment);
                  }),
              new IconButton(
                  icon: new Icon(
                    Icons.flag,
                    color: iconColor,
                  ),
                  onPressed: () async {
                    logger.finest('onFlag $deal');
                    _callAction(this.widget.onFlag);
                  }),
              new FlatButton(
                  onPressed: () {
                    debugPrint("view deal ${deal.title}");
                  },
                  child: new Text('VIEW DEAL'))
            ],
          ),
        ));
  }

  Widget _buildLikeButton(ThemeData theme) {
    return new GestureDetector(
        onTap: () async {
          logger.finest('onLike $deal');
          _callAction(this.widget.onLike);
        },
        child: new Chip(
            avatar: new CircleAvatar(
              child: new Text(
                deal.likes.toString(),
                style: theme.textTheme.caption.copyWith(color: Colors.white),
              ),
            ),
            label: new Icon(
              Icons.thumb_up,
              color: iconColor,
              size: 15.0,
            )));
  }

  _buildDealImage() {
    var dealImageSize = 80.0;
    return new Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(fit: BoxFit.cover, image: new NetworkImage(deal.imageUrl))),
      margin: new EdgeInsets.only(top: 10.0, left: 10.0),
      height: dealImageSize,
      width: dealImageSize,
    );
  }

  _buildPricingText(BuildContext context) {
    var theme = Theme.of(context);
    return new Padding(
        padding: new EdgeInsets.only(top: 4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  _regularPriceAsString,
                  style: theme.textTheme.caption.copyWith(decoration: TextDecoration.lineThrough),
                ),
                new Row(
                  children: <Widget>[
                    new Text(_discountPercentage),
                    new Padding(
                      padding: new EdgeInsets.only(left: 4.0),
                      child: new Text(
                        _priceAsString,
                        style: theme.textTheme.body1.copyWith(color: theme.accentColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
