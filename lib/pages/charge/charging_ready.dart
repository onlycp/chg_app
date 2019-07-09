import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/guns_model.dart';
import 'package:chp_app/model/station_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/**
 * 准备充电
 */
class ChargingReady extends StatefulWidget {
//  final StationModel station;
//  GunsModel gun;
//  ChargingReady(this.station, this.gun);
  final gunCode;
  ChargingReady(this.gunCode);
  @override
  _ChargeReady createState() => new _ChargeReady();
}

class _ChargeReady extends State<ChargingReady> {
  //手机号的控制器
  TextEditingController costController = TextEditingController();
  int physicalStatus;
  int gunStatus;
  GunsModel gunModel;
  String freeCost = '0';
  String freezeCost = '0';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalConfig.bgColor,
      appBar: AppBar(
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        title: const Text('返回'),
        centerTitle: true, // 居中
        elevation: 0,
      ),
      body: Container(
//        margin: EdgeInsets.all(20.0),
//        color: GlobalConfig.bgColor,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 10), color: Colors.white, padding: EdgeInsets.all(20), child: stationShow()),
                Container(margin: EdgeInsets.only(top: 20), color: Colors.white, padding: EdgeInsets.only(left: 10.0, right: 20), child: payShow()),
                Container(margin: EdgeInsets.only(top: 40), padding: EdgeInsets.only(left: 20.0, right: 20), child: submitButton()),
              ]
            )
        ),
      ),
    );
  }

  Widget stationShow() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
//            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    child: Row(children: <Widget>[
                      Text('${gunModel?.stationName}' == "null" ? "" : '${gunModel?.stationName}', style: TextStyle(fontSize: 18)),
                      Container(margin: EdgeInsets.only(left: 10.0)),
                      Text('${gunModel?.operateTypeName}' == "null" ? "" : '${gunModel?.operateTypeName}', style: TextStyle(color: Colors.yellow, fontSize: 12)),
                    ])
                ),
                Container(margin: EdgeInsets.only(top: 10.0)),
                InkWell(child: Row(
                    children: <Widget>[
                      Text('充电桩编号：'),
                      Text("${gunModel?.stationGunNo}" == "null" ? "" :'${gunModel?.stationGunNo}')
                    ])
                ),
                InkWell(child: Row(
                    children: <Widget>[
                      Text('连接状态：'), Text(physicalStatus == 1 ? ' 已连接' : ' 未连接', style: TextStyle(color: Colors.green))
                    ])
                ),
              ],
            )
        );
      },
    );
  }

  Widget payShow() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text('充电金额'),
                title: Container(
                    width: 180,
                    decoration: BoxDecoration(border: Border.all(color: GlobalConfig.bgColor, style: BorderStyle.solid, width: 1)),
                    child: TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), hintText: '15元', border: InputBorder.none),
                    )
                ),
              ),
              ListTile(
                  leading: Text('余额'),
                  title: Text('${freeCost}元'),
                  trailing: Container(
                      color: GlobalConfig.fontRedColor,
                      width: 120,
                      height: 30,
                      alignment: Alignment.center,
                      child: FlatButton.icon(onPressed: _pay, icon: Image.asset('img/coins.png'), label: new Text("我要充值", style: TextStyle(color: Colors.white, fontSize: 14)))
                  )
              )
            ],
          ),
        );
      },
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
//            shape: StadiumBorder(),
            child: Text("开始充电", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _pay() {
    if (Constants.token == null || Constants.token.length == 0)
      RouteUtil.route2Login(context);
    else
      RouteUtil.route2Pay(context);
  }

  void _submitButtonPressed() async {
    if (costController.text.length < 1) {
      NativeUtils.showToast('请输入充电具体金额');
      return;
    }

    if (Constants.token == null || Constants.token.length == 0)
      RouteUtil.route2Login(context);
    else {
      Dio dio = DioFactory.getInstance().getDio();
      try {
        Response response = await dio.post(Apis.startCharge,
            data: {"gunCode": widget.gunCode, 'cost': costController.text});

        if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
          setState(() {
//            widget.gun = response.data['data'];
            RouteUtil.route2ChargingMonitor(context);
          });
        }
        NativeUtils.showToast(response.data['message']);
      } catch (exception) {
        NativeUtils.showToast('您的网络似乎出了什么问题');
      }
    }
  }

  void _gunStatus() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.gunStatus,
          data: {"gunCode": widget.gunCode},
          options: new Options(contentType: ContentType.parse("application/x-www-form-urlencoded"))
      );

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          physicalStatus = response.data['physicalStatus'];
          gunStatus = response.data['gunStatus'];
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _gunModel() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.findPole,
          data: {"code": widget.gunCode},
          options: new Options(contentType: ContentType.parse("application/x-www-form-urlencoded"))
      );

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          gunModel = new GunsModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _myWallet() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.my);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          freeCost = response.data['data']['freeCost'];
          freezeCost = response.data['data']['freezeCost'];
//          userModel = new UserModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  @override
  void initState() {
    super.initState();
    _gunModel();
    _gunStatus();
    _myWallet();
  }
}
