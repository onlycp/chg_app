import 'package:chp_app/api/apis.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * 用户协议
 */
class Agreement extends StatefulWidget {
  @override
  _Agreement createState() => new _Agreement();
}

class _Agreement extends State<Agreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('用户协议'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, // 居中
      ),
      body: Container(
        color: GlobalConfig.bgColor,
        margin: EdgeInsets.all(10.0),
        child: WebView(
            initialUrl: Apis.agreement,
            javascriptMode: JavascriptMode.unrestricted),
      ),
    );
  }
}
