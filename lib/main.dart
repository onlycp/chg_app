import 'package:amap_base/amap_base.dart';
import 'package:chp_app/pages/charge/charging.dart';
import 'package:chp_app/pages/charge/charging_finish.dart';
import 'package:chp_app/pages/charge/charging_minitor.dart';
import 'package:chp_app/pages/charge/charging_scan.dart';
import 'package:chp_app/pages/charge/charging_station.dart';

import 'package:chp_app/pages/login.dart';
import 'package:chp_app/pages/my/my.dart';
import 'package:chp_app/pages/pay_fail.dart';
import 'package:chp_app/pages/pay_succeed.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:flutter/material.dart';

void main() async {
  await AMap.init('32656b457145017f73fb4e9e936152c5');
  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {

    NativeUtils.tabBarColor();
    return new MaterialApp(
      title: '新能源汽车',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white30,
      ),
      home: Scaffold(
        body: ChargingScreen(),
//            body: ChargingMonitor()
//            body: ChargingFinish()
//            body: ChargingScan()
//            body: ChargingStation()
//          body: PaySucceed(),
//          body: PayFail(),
//          body: My(),
      ),
    );
  }
}
