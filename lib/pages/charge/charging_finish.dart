import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/recharge_model.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:flutter/material.dart';

/**
 * 充电结束
 */
class ChargingFinish extends StatefulWidget {
  final RechargeModel rechargeModel;
  ChargingFinish(this.rechargeModel);

  @override
  _ChargingFinish createState() => new _ChargingFinish();
}

class _ChargingFinish extends State<ChargingFinish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.fitWidth, alignment: Alignment.topCenter, image: new ExactAssetImage("img/bg.png"))
        ),
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: FlatButton.icon(
                    onPressed: () {},
                    icon: Image.asset('img/back_left.png'),
                    label: Text('充电结束', style: TextStyle(color: Colors.white, fontSize: 18))
                ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30.0),
                child: ListTile(
                  leading: titleText(),
                  title: batteryText(),
                  trailing: batteryCharge(),
                )),
            Container(margin: EdgeInsets.only(top: 30.0)),
            stationDetail(),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Container(
        child: Column(children: <Widget>[
          Text("已充电量", style: TextStyle(color: Colors.white, fontSize: 14,)),
          Text("73W", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text("已充时长", style: TextStyle(color: Colors.white, fontSize: 14,)),
          Text("1小时10分钟", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ])
    );
  }

  Widget batteryText() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
            child: Column(children: <Widget>[
              Text("当前SOC", style: TextStyle(color: Colors.white, fontSize: 12,)),
              Text("100%", style: TextStyle(color: Colors.cyanAccent, fontSize: 12,)),
            ])
        );
      },
    );
  }

  Widget batteryCharge() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
//        color: Colors.white,
        decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.fill, image: new ExactAssetImage("img/battery_full.png"))
        ),
        width: 60,
        height: 120,
        alignment: Alignment.bottomCenter,
        child: Text(''));
  }

  Widget stationDetail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Card(
        child: Container(
            margin: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: ListTile(
                      title: Text('兰埔充电站'),
                      trailing: Text('公共充电站', style: TextStyle(color: Colors.yellow, fontSize: 12))
                  ),
                  subtitle: ListTile(
                      title: Text('充电站编号'),
                      trailing: Text('111122221')
                  ),
                  trailing: Image.asset('img/finish_badge.png'),
                ),
                ListTile(
                    leading: Icon(Icons.adjust),
                    title: Text('开始时间'),
                    trailing: Text('2018-9-11 12:00:00')),
                ListTile(
                    leading: Icon(Icons.adjust),
                    title: Text('结束时间'),
                    trailing: Text('2018-9-11 14:00:00')),
                ListTile(
                  title: Text('金额'),
                  trailing: Text('￥12.00', style: TextStyle(color: GlobalConfig.fontRedColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            )),
      ),
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
            child: Text("返回", style: TextStyle(color: Colors.white)),
            color: Colors.blue,
            onPressed: () {
              RouteUtil.route2Home(context);
            },
          ),
        );
      },
    );
  }
}
