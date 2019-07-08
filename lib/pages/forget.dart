import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:flutter/material.dart';

import 'package:chp_app/util/NetLoadingDialog.dart';

import 'package:dio/dio.dart';
import 'package:chp_app/api/apis.dart';
import 'dart:async';
import 'dart:io';

class Forget extends StatefulWidget {
  @override
  _Forget createState() {
    return new _Forget();
  }
}

class _Forget extends State<Forget> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  //密码的控制器
  TextEditingController passController = TextEditingController();

  String _verifyCode = '';
  int _seconds = 0;
  String _verifyStr = '获取验证码';
  Timer _timer;

  Color btnColor = GlobalConfig.btnFreeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text('忘记密码'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, // 居中
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 5.0)),
            Container(
              margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: titleText(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: userField(),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: _buildVerifyCodeEdit(),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 40),
              child: submitButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
//          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          width: double.infinity,
          child: Text("忘记密码", style: TextStyle(color: Colors.black, fontSize: 24)),
        );
      },
    );
  }

  Widget userField() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Row(
          children: <Widget>[
            Container(
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              child: Text("+86", style: TextStyle(color: Colors.black)),
            ),
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '请输入手机号',
                  border: InputBorder.none,
                  errorText: snapshot.error,
                ),
                autofocus: false,
              ),
            )
          ],
        );
      },
    );
  }

  Widget passwordField() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return TextField(
          controller: passController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
//              contentPadding: EdgeInsets.all(10.0),
              hintText: '6位以上密码',
              border: InputBorder.none,
//              labelText: '密码',
              errorText: snapshot.error),
          obscureText: true,
        );
        },
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {
          btnColor = str.length == 0
              ? GlobalConfig.btnFreeColor
              : GlobalConfig.btnColor;
        });
      },
      decoration: new InputDecoration(
        hintText: '请输入短信验证码',
        border: InputBorder.none,
      ),
//      maxLines: 1,
//      maxLength: 6,
//      //键盘展示为数字
//      keyboardType: TextInputType.number,
      //只能输入数字
//      inputFormatters: <TextInputFormatter>[
//        WhitelistingTextInputFormatter.digitsOnly,
//      ],
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0)
          ? () {
              _randCode();
              setState(() {
                _startTimer();
              });
            }
          : null,
      child: new Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 40.0,
        child: new Text('$_verifyStr', style: new TextStyle(fontSize: 16.0, color: GlobalConfig.fontRedColor)),
      ),
    );

    return new Row(
      children: <Widget>[
        Container(
          width: 50,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10),
          child: Text("验证码", style: TextStyle(color: Colors.black)),
        ),
        Expanded(
          child: verifyCodeEdit,
        ),
        new Align(
          alignment: Alignment.bottomRight,
          child: verifyCodeBtn,
        ),
      ],
    );
  }

  Widget submitButton() {
    return Container(
      width: double.infinity,
      height: 40,
      child: new Material(
        borderRadius: BorderRadius.circular(20.0),
        child: new MaterialButton(
          onPressed: (_submitButtonPressed),
          color: btnColor,
          child: Text("下一步", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _randCode() async {
//    _regPresenter.randCode(phoneController.text);
    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio.post(Apis.forgetRandCode,
          data: {"mobile": phoneController.text},
          options: new Options(contentType: ContentType.parse("application/x-www-form-urlencoded")));

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data'].toString();
      } else {
        RouteUtil.showAlertDialog(
            context, true, '错误提示', response.data['message']);
      }
    } catch (exception) {
      RouteUtil.showAlertDialog(context, true, '错误提示', '您的网络似乎出了什么问题');
    }
  }

  void _submitButtonPressed() async {
    showDialog(context: context, builder: (context) {
      return new NetLoadingDialog(loadingText: "正在加载中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
    });
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.forgetPasswordReady, data: {
        "mobile": phoneController.text,
        "randCode": _verifyCode,
        "randomId": Constants.token
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data'];
        RouteUtil.route2ForgetFinish(context);
      } else {
        RouteUtil.showAlertDialog(
            context, true, '错误提示', response.data['message']);
      }
    } catch (exception) {
      RouteUtil.showAlertDialog(context, true, '错误提示', '您的网络似乎出了什么问题');
    } finally {
      Navigator.pop(context);
    }
  }

  _startTimer() {
    _seconds = 10;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }
}
