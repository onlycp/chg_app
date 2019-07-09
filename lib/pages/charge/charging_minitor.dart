import 'dart:async';
import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/model/recharge_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:chp_app/widgets/back_button.dart';
import 'package:chp_app/widgets/event_details_scroll_effects.dart';
import 'package:chp_app/widgets/wave_progress.dart';
import 'package:dio/dio.dart';
import 'package:chp_app/util/NetLoadingDialog.dart';
import 'package:flutter/material.dart';

/**
 * 充电监控
 */
class ChargingMonitor extends StatefulWidget {
  @override
  _ChargingMonitor createState() => new _ChargingMonitor();
}

class _ChargingMonitor extends State<ChargingMonitor> {
  RechargeModel rechargeModel;
  EventDetailsScrollEffects _scrollEffects;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fitWidth, alignment: Alignment.topCenter, image: new ExactAssetImage("img/bg.png"))),
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 28),
                  alignment: Alignment.bottomCenter,
                  child: const Text('个人中心', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Baseline(baseline: 20.0, baselineType: TextBaseline.alphabetic, child: minitorShow()),
                        Baseline(baseline: 20.0, baselineType: TextBaseline.alphabetic, child: batteryText()),
                        Baseline(baseline: 120.0, baselineType: TextBaseline.alphabetic, child: batteryCharge())
                      ],
                    )
                ),
                stationDetail(),
                submitButton(),
              ],
            ),
          ),
          ReturnBack(_scrollEffects),
        ],
      ),
    );
  }

  Widget minitorShow() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Text("已充电量", style: TextStyle(color: Colors.white, fontSize: 14,))
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, left: 0),
                  child: Text('${rechargeModel?.chargedKw}', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
              ),
              Padding(
                  padding: EdgeInsets.only(left: 0, top: 10),
                  child: Text("已充时长", style: TextStyle(color: Colors.white, fontSize: 14,))
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, left: 0),
                  child: Text('${rechargeModel?.chargedTime}', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))
              ),
            ]));
  }

  Widget batteryText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("当前SOC", style: TextStyle(color: Colors.white, fontSize: 12,)),
                  Text("${rechargeModel?.soc}%", style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                ]
            )
        );
      },
    );
  }

  Widget batteryCharge() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
        decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: new ExactAssetImage("img/battery_empt.png"))),
        width: 60,
        height: 120,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 3, right: 3, top: 7, bottom: 3),
        child: SyWaveProgress(
            percent: (rechargeModel == null ? 0.1 : rechargeModel.soc / 100.0),
            primaryColor: Colors.yellow,
            secondaryColor: Colors.lightBlueAccent)
    );
  }

  Widget stationDetail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Card(
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                      child: InkWell(child: Text('${rechargeModel?.stationName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      padding: EdgeInsets.only(right: 10)
                  ),
                  Container(
                      child: InkWell(child: Text('公共充电站', style: TextStyle(color: Colors.yellow, fontSize: 12,))),
                      decoration: BoxDecoration(color: Colors.orangeAccent)
                  ),
                ]),
                Container(margin: EdgeInsets.only(top: 10.0)),
                Row(children: <Widget>[
                  InkWell(child: Text('充电站编号')),
                  InkWell(child: Text('${rechargeModel?.gunCode}'))
                ]),
                Container(margin: EdgeInsets.only(top: 20.0)),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 200,
                      child: Column(
                        children: <Widget>[
//                          Container(child: InkWell(child: Text('状态:')), alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 10)),
                          Container(child: InkWell(child: Text('总电流: ${rechargeModel?.chargedKw}')), alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 10)),
                          Container(child: InkWell(child: Text('总电压: ${rechargeModel?.currentVol}')), alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 10)),
                          Container(child: InkWell(child: Text('开始时间: ${rechargeModel?.chargedTime}')), alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 10)),
                          Container(child: InkWell(child: Text('金额: ￥${rechargeModel?.cost}')), alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
//            shape: StadiumBorder(),
            child: Text("停止充电", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
            onPressed: () {
              _stop();
            },
          ),
        );
      },
    );
  }

  void _stop() async {
    showDialog(
        context: context,
        builder: (context) {
          return new NetLoadingDialog(
            loadingText: "正在停止充电...",
            dismissDialog: _disMissCallBack,
            outsideDismiss: true,
          );
        }
    );
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.stopCharge,
          data: {"gunCode": rechargeModel.gunCode},
          options: new Options(
              contentType:
              ContentType.parse("application/x-www-form-urlencoded"))
      );

      Navigator.of(context).pop(true);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          final rm = new RechargeModel.fromJson(response.data["data"]);
          RouteUtil.route2ChargingFinish(context, rm);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      Navigator.of(context).pop(true);
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _loadByTime() async {
    _loadData();
    _timer = new Timer.periodic(const Duration(milliseconds: 15000), (timer) {
      _loadData();
    });
  }

  void _loadData() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.realInfo);

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          rechargeModel = new RechargeModel.fromJson(response.data["data"]);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
        Navigator.maybePop(context);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollEffects = EventDetailsScrollEffects();

    _loadByTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
