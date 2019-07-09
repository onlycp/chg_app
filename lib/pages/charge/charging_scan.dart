import 'dart:async';

import 'package:chp_app/util/NativeUtils.dart';
import 'package:flutter/material.dart';

/**
 * 扫码充电
 */
class ChargingScan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ChargingScan> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.pop(context);
              }),
          title: new Text('扫码'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(color: Colors.blue, textColor: Colors.white, splashColor: Colors.blueGrey, onPressed: scan, child: const Text('START CAMERA SCAN')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center),
              ),
            ],
          ),
        )
    );
  }

  Future scan() async {
    String barcode = await NativeUtils.scanf();
    setState(() => this.barcode = barcode);
  }
}
