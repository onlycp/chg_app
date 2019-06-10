import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:flutter/material.dart';

/**
 * 充值成功
 */
class PaySucceed extends StatefulWidget {
  @override
  _PaySucceed createState() => new _PaySucceed();
}

class _PaySucceed extends State<PaySucceed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('支付成功'),
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
            Image.asset(
              'img/success.png',
              fit: BoxFit.cover,
            ),
            titleText(),
            Container(margin: EdgeInsets.only(top: 30.0)),
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
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                ListTile(leading: Text("充值前余额:"), title: Text("10元")),
                ListTile(leading: Text("充值金额:"), title: Text("10元")),
                ListTile(
                    leading: Text("当前余额:"),
                    title: Text(
                      "20元",
                      style: TextStyle(color: GlobalConfig.fontRedColor),
                    ))
              ],
            ));
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
            child: Text(
              "完成",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              RouteUtil.route2PayFail(context);
            },
          ),
        );
      },
    );
  }
}
