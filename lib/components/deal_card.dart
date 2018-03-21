import 'package:discount_machine/model/deal.dart';
import 'package:flutter/material.dart';

class DealCard extends StatefulWidget {
  final Deal deal;

  DealCard(this.deal);

  @override
  _DealCardState createState() => new _DealCardState(deal);
}

class _DealCardState extends State<DealCard> {
  final Deal deal;

  _DealCardState(this.deal);

  String get _priceAsString => "\$${deal.price.toString()}";

  String get _regularPriceAsString => "\$${deal.regularPrice.toString()}";

  String get _discountPercentage => deal.discountPercentageString;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dealImageSize = 80.0;
    var iconColor = Colors.blueGrey;

    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover, image: new NetworkImage(deal.imageUrl))),
              margin: new EdgeInsets.only(top: 10.0, left: 10.0),
              height: dealImageSize,
              width: dealImageSize,
            ),
            new Expanded(
              child: new ListTile(
                dense: true,
                title: new Text(deal.title),
                subtitle: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[new Text(deal.merchant), new Text(deal.timeAgo)],
                    ),
                    new Padding(
                        padding: new EdgeInsets.only(top: 4.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  _regularPriceAsString,
                                  style: theme.textTheme.caption
                                      .copyWith(decoration: TextDecoration.lineThrough),
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Text(_discountPercentage),
                                    new Padding(
                                      padding: new EdgeInsets.only(left: 4.0),
                                      child: new Text(
                                        _priceAsString,
                                        style: theme.textTheme.body1
                                            .copyWith(color: theme.accentColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ]),
          new Container(
              child: new ButtonTheme.bar(
            child: new ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new GestureDetector(
                    onTap: () {
                      debugPrint("Like deal");
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
                        ))),
                new IconButton(
                    icon: new Icon(
                      Icons.comment,
                      color: iconColor,
                    ),
                    onPressed: () {
                      debugPrint("Comment on deal");
                    }),
                new IconButton(
                    icon: new Icon(
                      Icons.flag,
                      color: iconColor,
                    ),
                    onPressed: () {
                      debugPrint("Flag on deal");
                    }),
                new FlatButton(
                    onPressed: () {
                      debugPrint("view deal ${deal.title}");
                    },
                    child: new Text('VIEW DEAL'))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
