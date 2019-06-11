import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chp_app/pages/charge/charging.dart';

class Login extends StatefulWidget {
  @override
  _LoginScreen createState() => new _LoginScreen();
}

class _LoginScreen extends State<Login> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  //密码的控制器
  TextEditingController passController = TextEditingController();
  Color btn_color = GlobalConfig.btnFreeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.pop(context);
              }),
          title: const Text('登录'),
          centerTitle: true, // 居中
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 4), color: GlobalConfig.bgColor),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: titleText(),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                      child: userField(),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: passwordField(),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 40),
                      child: submitButton(),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: forgotLabel(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget titleText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          width: double.infinity,
          child: Text(
            "用户登录",
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
          onChanged: _textFieldChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            hintText: '请输入手机号',
            errorText: snapshot.error,
            border: InputBorder.none,
          ),
          autofocus: false,
        );
      },
    );
  }

  Widget passwordField() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return TextField(
          controller: passController,
          onChanged: _textFieldChanged,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: '6位以上密码',
              border: InputBorder.none,
              errorText: snapshot.error),
          obscureText: true,
        );
      },
    );
  }

  Widget forgotLabel() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: GestureDetector(
                onTapUp: (tapDetail) {
                  RouteUtil.route2Reg(context);
                },
                child: Text(
                  "手机号快速注册",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: GlobalConfig.fontRedColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: GestureDetector(
                onTapUp: (tapDetail) {
                  RouteUtil.route2Forget(context);
//                  RouteUtil.showTips(context, '注册了吗');
                },
                child: Text(
                  "忘记密码",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: GlobalConfig.fontRedColor),
                ),
              ),
            ),
          )
        ],
      ),
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
            child: Text(
              "登录",
              style: TextStyle(color: Colors.white),
            ),
            color: btn_color,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _submitButtonPressed() async {
    Dio dio = DioFactory.getInstance().getDio();
//    final _rand = await encryptString('111111', Constants.PUBLIC_KEY);
    if (phoneController.text.length < 1 || phoneController.text.length < 1) {
      NativeUtils.showToast('手机号或密码不能为空');
      return;
    }
    final _rand = await NativeUtils.encrypt(passController.text, Constants.PUBLIC_KEY);
    try {
      Response response = await dio.post(Apis.login, data: {
        "mobile": phoneController.text,
        "password": _rand.replaceAll(new RegExp(r'\n'), '')
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data']['token'];
        Constants.refreshToken = response.data['data']['refreshToken'];
        if (Constants.token.length > 0) {
          //登录成功关闭登录页面,跳转个人信息
          _setToken();
          Navigator.maybePop(context);
        }
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _textFieldChanged(String str) {
    setState(() {
      if (passController.text.length > 0 && phoneController.text.length > 0) {
        btn_color = GlobalConfig.btnColor;
      } else {
        btn_color = GlobalConfig.btnFreeColor;
      }
    });
  }

//  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      phoneController.text = '18614092910';
//      passController.text = '111111';
//    });
//  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> _setToken() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('token', Constants.token);
      prefs.setString('refreshToken', Constants.refreshToken);
    });

//    setState(() {
//      _counter = prefs.setInt("counter", counter).then((bool success) {
//        return counter;
//      });
//    });
  }
}
