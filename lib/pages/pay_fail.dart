import 'package:chp_app/util/route_util.dart';
import 'package:flutter/material.dart';

/**
 * 充值失败
 */
class PayFail extends StatefulWidget {
  @override
  _PayFail createState() => new _PayFail();
}

class _PayFail extends State<PayFail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('支付失败'),
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
            Image.asset('img/fail.png', fit: BoxFit.cover),
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
          child: Text("钱包充值失败"),
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
            child: Text("完成", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
            onPressed: () {
              RouteUtil.route2My(context);
            },
          ),
        );
      },
    );
  }
}
