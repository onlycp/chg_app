import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:flutter/material.dart';
import 'package:chp_app/util/NetLoadingDialog.dart';

import 'package:dio/dio.dart';
import 'package:chp_app/api/apis.dart';
import 'dart:io';

class ForgetFinish extends StatefulWidget {
  @override
  _ForgetFinish createState() {
    return new _ForgetFinish();
  }
}

class _ForgetFinish extends State<ForgetFinish> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  //密码的控制器
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('修改密码'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, // 居中
      ),
      body: SingleChildScrollView(
//        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), child: titleText()),
            Container(margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0), child: userField()),
            Divider(),
            Container(margin: EdgeInsets.only(left: 20.0, right: 20.0), child: passwordField()),
            Divider(),
            Container(margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40), child: submitButton()),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(width: double.infinity, child: Text("修改密码", style: TextStyle(color: Colors.black, fontSize: 24)),
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
          decoration: InputDecoration(hintText: '请输入密码', border: InputBorder.none, errorText: snapshot.error),
          autofocus: false,
          obscureText: true,
        );
      },
    );
  }

  Widget passwordField() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return TextField(
          controller: passController,
          decoration: InputDecoration(border: InputBorder.none, hintText: '请再次输入密码', errorText: snapshot.error),
          obscureText: true,
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
            child: Text("确认提交", style: TextStyle(color: Colors.white)),
            color: GlobalConfig.btnColor,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _submitButtonPressed() async {
    if(!phoneController.text.toString().endsWith(passController.text.toString())) {
      NativeUtils.showToast("两次密码不一致，请重新输入");
      return;
    }
    showDialog(context: context, builder: (context) {
      return new NetLoadingDialog(loadingText: "正在加载中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
    });
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    final _password = await NativeUtils.encrypt(passController.text, Constants.PUBLIC_KEY);
    try {
      Response response = await dio.post(Apis.forgetSetPassword, data: {
//        "mobile": phoneController.text,
        "password": _password.replaceAll(new RegExp(r'\n'), ''),
        "randomId": Constants.token
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data']['token'];
        Constants.refreshToken = response.data['data']['refreshToken'];
        RouteUtil.route2Home(context);
      } else {
        RouteUtil.showAlertDialog(context, true, '错误提示', response.data['message']);
      }
    } catch (exception) {
      RouteUtil.showAlertDialog(context, true, '错误提示', '您的网络似乎出了什么问题');
    } finally {
      Navigator.pop(context);
    }
  }
}
