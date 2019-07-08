import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chp_app/util/NetLoadingDialog.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {

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
          title: const Text('修改密码'),
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

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void _submitButtonPressed() async {
    if (pwd.text.length < 6 || pwdAgain.text.length < 6) {
      NativeUtils.showToast('请输入6位以上密码');
      return;
    }else if (!pwd.text.endsWith(pwdAgain.text)) {
      NativeUtils.showToast('两次密码不一致，请重新输入');
      return;
    }
    showDialog(context: context, builder: (context) {
      return new NetLoadingDialog(loadingText: "正在加载中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
    });
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    final rand_pwd = await NativeUtils.encrypt(pwd.text, Constants.PUBLIC_KEY);
    final SharedPreferences prefs = await _prefs;
    try {
      Response response = await dio.post(Apis.updatePassword, data: {
        "newPassword": rand_pwd.replaceAll(new RegExp(r'\n'), ''),
        "oldPassword": prefs.get(Constants.PASSWORD)
      });
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        prefs.setString(Constants.PASSWORD, rand_pwd.replaceAll(new RegExp(r'\n'), ''));
        Navigator.pop(context);
      }
      NativeUtils.showToast(response.data['message']);
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    } finally {
      Navigator.of(context).pop(true);
    }
  }
}