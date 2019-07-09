import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chp_app/util/NetLoadingDialog.dart';

class RegFinish extends StatefulWidget {
  @override
  _RegFinish createState() => new _RegFinish();
}

class _RegFinish extends State<RegFinish> {

  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  //密码的控制器
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('设置密码'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, // 居中
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 30.0)),
                titleText(),
                Container(margin: EdgeInsets.only(top: 30.0)),
                userField(),
                Container(margin: EdgeInsets.only(top: 30.0)),
                passwordField(),
                Container(margin: EdgeInsets.only(top: 60.0)),
                submitButton(),
              ],
            )
        ),
      ),
    );
  }

  Widget titleText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          width: double.infinity,
          child: Text("设置密码", style: TextStyle(color: Colors.black, fontSize: 24)),
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
          decoration: InputDecoration(contentPadding: EdgeInsets.all(10.0), hintText: '请输入密码', errorText: snapshot.error),
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
          decoration: InputDecoration(contentPadding: EdgeInsets.all(10.0), hintText: '请再次输入密码', errorText: snapshot.error),
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
    if (passController.text.length < 6 || passController.text.length < 6) {
      NativeUtils.showToast('请输入6位以上密码');
      return;
    }else if (!passController.text.endsWith(passController.text)) {
      NativeUtils.showToast('两次密码不一致，请重新输入');
      return;
    }
    showDialog(context: context, builder: (context) {
      return new NetLoadingDialog(loadingText: "正在注册中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
    });
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    final _rand = await NativeUtils.encrypt(passController.text, Constants.PUBLIC_KEY);

    try {
      Response response = await dio.post(Apis.setPassword, data: {
        "password": _rand.replaceAll(new RegExp(r'\n'), ''),
        "randomId": Constants.token
      });
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        Constants.token = response.data['data'].toString();
        RouteUtil.route2Home(context);
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    } finally {
      Navigator.pop(context);
    }
  }
}
