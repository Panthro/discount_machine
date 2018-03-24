import 'dart:async';
import 'dart:math';

import 'package:discount_machine/components/deal_list.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/stores/deal_store.dart';
import 'package:discount_machine/stores/fresh_deal_store.dart';
import 'package:flutter/material.dart';

class FreshDealsPage extends StatefulWidget {
  final FreshDealStore store;

  FreshDealsPage() : store = new FreshDealStore();

  @override
  FreshDealsPageState createState() {
    return new FreshDealsPageState();
  }
}

class FreshDealsPageState extends State<FreshDealsPage> {
  List<Deal> deals = [];

  @override
  void initState() {
    deals = widget.store.freshDeals;
    widget.store.listen((_) => setState(() {
          deals = widget.store.freshDeals;
        }));
    widget.store.loadMore();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new DealList(
        deals,
        onLoadMore: widget.store.loadMore,
        onRefresh: () async => await widget.store.loadMore(refresh: true),
      ),
    );
  }
}
