import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/alipay_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:chp_app/cfg.dart';

/**
 * 充值
 */
class Pay extends StatefulWidget {
  @override
  _Pay createState() => new _Pay();
}

class _Pay extends State<Pay> {
  final myController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('充值'),
        centerTitle: true, // 居中
        elevation: 1,
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: GlobalConfig.bgColor,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 5.0),
                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                child: titleText()),
            Container(
                margin: EdgeInsets.only(top: 1.0),
                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                child: userField()),
            Container(
                margin: EdgeInsets.only(top: 30.0),
//                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                child: radioButton()),
            Container(
                margin: EdgeInsets.only(top: 40.0),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: submitButton()),
          ],
        )),
      ),
    );
  }

  Widget titleText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
//          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          width: double.infinity,
          child: Row(children: <Widget>[
            Text("余额(元):", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
            Text("100", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE))
          ]),
        );
      },
    );
  }

  Widget userField() {
    return Row(children: <Widget>[
      Container(
        width: 100,
        child: Text('充值金额(元):', style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
      ),
      Container(
          width: 180,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black12, style: BorderStyle.solid, width: 1)),
          child: TextField(
            controller: myController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                hintText: '请输入金额',
                border: InputBorder.none),
//                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0))),
          ))
    ]);
  }

  String _newValue = '微信';
  Widget radioButton() {
    return new Container(
      child: new Column(
        children: <Widget>[
          InkWell(
              child: new RadioListTile<String>(
            value: '微信',
            title: InkWell(
                child: Row(
              children: <Widget>[
                Image.asset('img/weixin.png'),
                Container(margin: EdgeInsets.only(left: 10)),
                Text('微信')
              ],
            )),
            groupValue: _newValue,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                _newValue = value;
              });
            },
          )),
          Divider(),
          InkWell(
              child: new RadioListTile<String>(
            value: '支付宝',
            title: InkWell(
                child: Row(
              children: <Widget>[
                Image.asset('img/zhifubao.png'),
                Container(margin: EdgeInsets.only(left: 10)),
                Text('支付宝')
              ],
            )),
            groupValue: _newValue,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                _newValue = value;
              });
            },
          )),
        ],
      ),
    );
  }

  Widget submitButton() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
//            shape: StadiumBorder(),
            child: Text("确认", style: TextStyle(color: Colors.white, fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
            color: Colors.blue,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _submitButtonPressed() {
    if (_newValue == '支付宝') {
      callAlipay();
    } else {
      callFluwx();
    }
  }

  void callFluwx() async {
    dynamic payResult;
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.readyRecharge,
          data: {"cost": myController.text, "type": 1});

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        _payInfo = response.data['data']['wxPayReq'];
        fluwx.pay(
            appId: 'wxb4ba3c02aa476ea1',
            partnerId: '1900006771',
            prepayId: 'wx08181452603791323f21207a1102006032',
            packageValue: 'Sign=WXPay',
            nonceStr: 'ac5d9d23855aa5a015b0cc6031281f4c',
            timeStamp: 1562580892,
            sign: 'F543FB5220C8A733FB60EAE78090A810').then((data) {
          print("---》$data");
        });
        if (!mounted) return;
        setState(() {
          _payResult = payResult;
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  String _payInfo = "创建订单失败";
  AlipayResult _payResult;

  void callAlipay() async {
    dynamic payResult;
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.readyRecharge,
          data: {"cost": myController.text, "type": 0});

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        _payInfo = response.data['data']['alipayReq'];
        _payInfo = _payInfo.replaceAll(
            'https://openapi.alipaydev.com/gateway.do?', '');
//        _payInfo.replaceAll('https://openapi.alipay.com/gateway.do?', '');
        print(_payInfo);
        payResult = await FlutterAlipay.pay(_payInfo);
        if (!mounted) {
          RouteUtil.route2PayFail(context);
          return;
        }
        setState(() {
          _payResult = payResult;
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }
}
