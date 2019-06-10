import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

class Reg extends StatefulWidget {
  @override
  _Reg createState() => new _Reg();
}

class _Reg extends State<Reg> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  String _verifyCode = '';
  int _seconds = 0;
  String _verifyStr = '获取验证码';
  Timer _timer;

  Color btnColor = GlobalConfig.btnFreeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1,
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: const Text('手机快速注册'),
        centerTitle: true, // 居中
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
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
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: forgotLabel(),
            ),
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
          child: Text(
            "手机快速注册",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        );
      },
    );
  }

  Widget userField() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return TextField(
          controller: phoneController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
//            contentPadding: EdgeInsets.all(10.0),
            hintText: '请输入手机号',
            border: InputBorder.none,
            errorText: snapshot.error,
          ),
          autofocus: false,
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
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        hintText: '请输入短信验证码',
        border: InputBorder.none,
      ),
//      maxLines: 1,
//      maxLength: 6,
      //键盘展示为数字
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
        child: new Text('$_verifyStr',
            style: new TextStyle(
                fontSize: 16.0, color: GlobalConfig.fontRedColor)),
      ),
    );

    return new Stack(
      children: <Widget>[
        verifyCodeEdit,
        new Align(
          alignment: Alignment.bottomRight,
          child: verifyCodeBtn,
        ),
      ],
    );
  }

  Widget forgotLabel() {
    return GestureDetector(
        onTapUp: (tapDetail) {
          RouteUtil.route2Agreement(context);
        },
        child: InkWell(
            child: Row(children: <Widget>[
          Text('点击下一步，即表示已阅读并同意'),
          Text(
            '《用户协议》',
            style: TextStyle(color: GlobalConfig.fontRedColor),
          )
        ]))
//      child: Text('点击下一步，即表示已阅读并同意《用户协议》'),
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
      Response response = await dio.post(Apis.registerRandCode,
          data: {"mobile": phoneController.text},
          options: new Options(
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded")));

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
    //短信验证码
//    _regPresenter.reg(phoneController.text, _verifyCode);
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.registerReady, data: {
        "mobile": phoneController.text,
        "randCode": _verifyCode,
        "randomId": Constants.token
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data'].toString();
        RouteUtil.route2RegFinish(context);
      } else {
        RouteUtil.showAlertDialog(
            context, true, '错误提示', response.data['message']);
      }
    } catch (exception) {
      RouteUtil.showAlertDialog(context, true, '错误提示', '您的网络似乎出了什么问题');
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
