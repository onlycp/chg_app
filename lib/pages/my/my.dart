import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/user_model.dart';
import 'package:chp_app/model/version_model.dart';
import 'package:chp_app/pages/charge/charging.dart';
import 'package:chp_app/pages/login.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:chp_app/widgets/back_button.dart';
import 'package:chp_app/widgets/event_details_scroll_effects.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chp_app/cfg.dart';

/**
 * 个人中心
 */
class My extends StatefulWidget {
  @override
  _My createState() {
    return new _My();
  }
}

class _My extends State<My> {
  UserModel userModel;
  String freeCost;
  String freezeCost;
  String newVersion = "";

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Container(
        color: GlobalConfig.bgColor,
        child: Column(
          children: <Widget>[
            myInfoCard(),
            Expanded(
              child: SingleChildScrollView(
                child: btnCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myInfoCard() {
    return new Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: new ExactAssetImage("img/personal_bg.png"))),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 60),
                    alignment: Alignment.center,
                    child: Text('个人中心', style: TextStyle(color: Colors.white, fontSize: Cfg.FONT_SIZE_PAGE_TITLE))
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(left: 30.0, top: 12.0),
            child: new ListTile(
              leading: new Container(
                child: new CircleAvatar(
                    backgroundImage: new NetworkImage("${userModel?.photoUrl}"),
                    radius: 30.0),
              ),
              title: new Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 2.0, left: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("${userModel?.realName}",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      new Text("${userModel?.mobile}",
                          style: TextStyle(color: Colors.white)),
                      Row(children: <Widget>[
                        new Text("余额",
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 12)),
                        Container(margin: EdgeInsets.only(left: 10)),
                        new Text("￥${freeCost}",
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 16))
                      ]),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget btnCard() {
    return Column(children: [
      new Container(
          child: Column(
        children: <Widget>[
          Divider(height: 1),
          new InkWell(
            onTap: () {
              RouteUtil.route2MyInfo(context);
            },
            child: new Container(
              color: Colors.white,
              height: 50,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Text("个人资料", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset('img/more_right.png')),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          new InkWell(
            onTap: () {
              RouteUtil.route2Orders(context);
            },
            child: new Container(
              color: Colors.white,
              height: 50,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Text("充电订单", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset('img/more_right.png')),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          new InkWell(
              onTap: () {
                RouteUtil.route2Pay(context);
              },
              child: new Container(
                color: Colors.white,
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("充值", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('img/more_right.png')),
                  ],
                ),
              )),
          Divider(height: 1),
          new InkWell(
              onTap: () {
                RouteUtil.route2Trade(context);
              },
              child: new Container(
                color: Colors.white,
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("交易明细", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('img/more_right.png')),
                  ],
                ),
              )),
          Divider(height: 1),
          new InkWell(
              onTap: () {
                RouteUtil.route2ChangePWD(context);
              },
              child: new Container(
                color: Colors.white,
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("登录密码", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('img/more_right.png')),
                  ],
                ),
              )),
          Divider(height: 1),
          new InkWell(
              onTap: () {
                RouteUtil.route2ChangeChargingPWD(context);
              },
              child: new Container(
                color: Colors.white,
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("充电密码", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('img/more_right.png')),
                  ],
                ),
              )),
          Divider(height: 1),
        ],
      )),
      new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Divider(height: 1),
            new InkWell(
              onTap: () {
                RouteUtil.route2Questions(context);
              },
              child: new Container(
                color: Colors.white,
                height: 50,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text("常见问题", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('img/more_right.png')),
                  ],
                ),
              ),
            ),
            Divider(height: 1),
            new InkWell(
                onTap: () {
                  RouteUtil.route2Ask(context);
                },
                child: new Container(
                  color: Colors.white,
                  height: 50,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Text("问题反馈", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('img/more_right.png')),
                    ],
                  ),
                )),
//            Divider(height: 1),
//            new InkWell(
//              onTap: () {
//                NativeUtils.callPhoneNumber(context, "11111");
//              },
//              child: new Container(
//                color: Colors.white,
//                height: 50,
//                child: new Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Container(
//                        padding:
//                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                        alignment: Alignment.centerLeft,
//                        child: Text("客服电话", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
//                      ),
//                    ),
//                    Container(
//                        margin: EdgeInsets.only(right: 10),
//                        child: Image.asset('img/more_right.png')),
//                  ],
//                ),
//              ),
//            ),
            Divider(height: 1),
          ],
        ),
      ),
      new Offstage(
        offstage: Platform.isIOS,
        child: new Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Divider(height: 1),
              new InkWell(
                onTap: () {
                  _update(true);
                },
                child: Container(
                  color: Colors.white,
                  height: 50,
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Text("检查升级", style: TextStyle(fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            newVersion,
                            style: TextStyle(color: Colors.red),
                          )),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('img/more_right.png')),
                    ],
                  ),
                ),
              ),
              Divider(height: 1),
            ],
          ),
        ),
      ),
      new Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Divider(height: 1),
            new InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => new AlertDialog(
                            title: new Text('确定要退出系统'),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("退出",
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  Constants.user = null;
                                  Constants.token = '';
                                  Constants.refreshToken = '';
                                  _exitAccount();
                                },
                              ),
                              new FlatButton(
                                child: new Text("取消",
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                              )
                            ]));
              },
              child: Container(
                color: GlobalConfig.fontRedColor,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.center,
                child: Text("注销", style: TextStyle(color: Colors.white, fontSize: Cfg.FONT_SIZE_PAGE_TITLE)),
              ),
            ),
            Divider(height: 1),
          ],
        ),
      ),
    ]);
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void _exitAccount() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('token', '');
      prefs.setString('refreshToken', '');
    });
    //第一次pop diglog，第二次pop页面
    Navigator.pop(context);
    Navigator.pop(context);
    RouteUtil.route2Login(context);
  }

  void _getInfo() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.info);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          userModel = new UserModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _myWallet() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.my);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          freeCost = response.data['data']['freeCost'];
          freezeCost = response.data['data']['freezeCost'];
//          userModel = new UserModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _update(showdialog) async {
    int version = await NativeUtils.getVersion();
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.checkVersion);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        if (response.data['data']['intVersion'] > version) {
          setState(() {
            newVersion = "新版本" + response.data['data']['version'];
          });
          if (showdialog) {
            RouteUtil.showCustomAlertDialog(
                context,
                true,
                '版本更新',
                response.data['data']['note'],
                new FlatButton(
                  child: new Text("好的", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    NativeUtils.downloadApp(response.data['data']['url']);
//                    _downApk(response.data['data']['url']);
                  },
                ));
          }
        }
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _downApk(url) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response =
          await dio.download(url, "./chp.apk", onProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      });
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  EventDetailsScrollEffects _scrollEffects;

  @override
  void initState() {
    super.initState();
    _scrollEffects = EventDetailsScrollEffects();
    _getInfo();
    _myWallet();
    if (Platform.isAndroid) {
      _update(false);
    }
  }
}
