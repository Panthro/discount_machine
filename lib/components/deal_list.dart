import 'dart:async';

import 'package:discount_machine/components/deal_card.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

typedef LoadMoreDealsCallback(Deal lastDeal);

class DealList extends StatefulWidget {
  final Logger logger = new Logger('DealList');

  final List<Deal> deals;
  final DealActionCallback onLike;
  final DealActionCallback onFlag;
  final DealActionCallback onComment;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final int pageThreshold;

  DealList(this.deals,
      {this.onRefresh,
      this.onLoadMore,
      this.onLike,
      this.onFlag,
      this.onComment,
      this.pageThreshold: 10});

  @override
  DealListState createState() {
    return new DealListState(deals);
  }
}

class DealListState extends State<DealList> {
  final List<Deal> deals;
  final ScrollController _scrollController = new ScrollController();
  bool _loadingMore = false;

  DealListState(this.deals);

  void _loadMore() {
    if (this.widget.onLoadMore != null && !_loadingMore) {
      _loadingMore = true;
      new Future(() async {
        widget.logger.fine('Loading more deals');
        widget.logger.fine('Last deal ${deals.last}');
        widget.onLoadMore();
      }).then((_) => setState(() => _loadingMore = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget list = new ListView.builder(
        controller: _scrollController,
        itemCount: deals.length,
        itemBuilder: (context, index) {
          widget.logger.finest('Loading deal $index');
          if (!_loadingMore && index + widget.pageThreshold > deals.length
              && _scrollController.offset != _scrollController.initialScrollOffset
          ) {
            _loadMore();
          }

          return new DealCard(
            widget.deals[index],
            onLike: widget.onLike,
            onComment: widget.onComment,
            onFlag: widget.onFlag,
          );
        });

//    if (widget.onLoadMore != null) {
//      list = new NotificationListener<OverscrollNotification>(
//        child: list,
//        onNotification: (notification) {
//          if (!_loadingMore) {
//            _loadMore();
//          }
//        },
//      );
//    }

    if (widget.onRefresh != null) {
      list = new RefreshIndicator(child: list, onRefresh: widget.onRefresh);
    }
    return list;
  }
}
