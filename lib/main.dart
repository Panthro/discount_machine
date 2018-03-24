import 'dart:async';

import 'package:discount_machine/components/deal_list.dart';
import 'package:discount_machine/model/deal.dart';
import 'package:discount_machine/page/fresh_deals.dart';
import 'package:discount_machine/stores/deal_store.dart';
import 'package:discount_machine/stores/fresh_deal_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:logging/logging.dart';

import './commons/log.dart';

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension();
  setupLogger(level: Level.FINE);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
//        primarySwatch: Colors.primaries[new Random().nextInt(Colors.primaries.length)],
        primarySwatch: Colors.deepOrange,
      ),
      home: new FreshDealsPage(),
    );
  }
}
