import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chp_app/api/apis.dart';

class ChargingNumber extends StatefulWidget {
  @override
  _ChargeNumber createState() => new _ChargeNumber();
}

class _ChargeNumber extends State<ChargingNumber> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('返回'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, // 居中
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 30.0)),
            titleText(),
            Container(margin: EdgeInsets.only(top: 30.0)),
            userField(),
            Container(margin: EdgeInsets.only(top: 60.0)),
            submitButton(),
          ],
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
          child: Text(
            "请输入充电桩编码",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
            contentPadding: EdgeInsets.all(10.0),
            hintText: '充电桩编码',
            errorText: snapshot.error,
          ),
          autofocus: true,
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
            child: Text(
              "前往充电",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _submitButtonPressed() async {
    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.post(Apis.login, data: {
        "deviceType": 1,
        "model": {
          "mobile": phoneController.text,
        }
      });
    } on DioError catch (e) {
      print(e.message);
    }
    print(response.data);
  }
}
