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
class ChangeChargingPWD extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeChargingPWD();
}

class _ChangeChargingPWD extends State<ChangeChargingPWD> {

  //手机号的控制器
  TextEditingController pwd = TextEditingController();
  //密码的控制器
  TextEditingController pwdAgain = TextEditingController();

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
          title: const Text('修改充电密码'),
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
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                      child: passwordField(pwd, "新密码"),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: passwordField(pwdAgain, "确认密码"),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 40),
                      child: submitButton(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void _textFieldChanged(String str) {
    setState(() {
      if (pwd.text.length >= 6 && pwdAgain.text.length >= 6) {
        btn_color = GlobalConfig.btnColor;
      } else {
        btn_color = GlobalConfig.btnFreeColor;
      }
    });
  }

  Widget submitButton() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
            color: btn_color,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  Widget passwordField(TextEditingController controller, String hinText) {
    return StreamBuilder(
      builder: (context, snapshot) {
        return TextField(
          controller: controller,
          onChanged: _textFieldChanged,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: hinText,
              border: InputBorder.none,
              errorText: snapshot.error),
          obscureText: true,
        );
      },
    );
  }

  void _submitButtonPressed() async {
    Dio dio = DioFactory.getInstance().getDio();
    if (pwd.text.length < 6 || pwdAgain.text.length < 6) {
      NativeUtils.showToast('请输入6位以上密码');
      return;
    }
    final _rand = await NativeUtils.encrypt(pwd.text, Constants.PUBLIC_KEY);
    try {
      Response response = await dio.post(Apis.login, data: {
        "mobile": pwd.text,
        "password": _rand.replaceAll(new RegExp(r'\n'), '')
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data']['token'];
        Constants.refreshToken = response.data['data']['refreshToken'];
        if (Constants.token.length > 0) {
          //登录成功关闭登录页面,跳转个人信息
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            prefs.setString('token', Constants.token);
            prefs.setString('refreshToken', Constants.refreshToken);
          });
        }
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }
}