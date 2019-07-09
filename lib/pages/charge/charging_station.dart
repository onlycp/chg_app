import 'dart:async';
import 'dart:io';

import 'package:amap_base/amap_base.dart';
import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/guns_model.dart';
import 'package:chp_app/model/station_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/**
 * 充电站
 */
class ChargingStation extends StatefulWidget {
  final StationModel station;
  ChargingStation(this.station);

  @override
  _ChargingStation createState() => new _ChargingStation();
}

class _ChargingStation extends State<ChargingStation> {
  List<String> images = [""];
  StationModel stationDetail;
  List<GunsModel> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {Navigator.pop(context);}
          ),
          title: Text('${stationDetail?.name}'),
          centerTitle: true, // 居中
          elevation: 0,
        ),
        body: swiper(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 265.0)),
            station(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(child: Container(height: 1, color: GlobalConfig.lineColor, margin: EdgeInsets.only(right: 10))),
                  Text("终端列表", style: TextStyle(color: GlobalConfig.lineColor)),
                  Expanded(child: Container(height: 1, color: GlobalConfig.lineColor, margin: EdgeInsets.only(left: 10))),
                ],
              ),
            ),
            Expanded(child: ListView.builder(itemCount: list?.length, itemBuilder: buildItem))
          ],
        )
    );
  }

  Widget buildItem(BuildContext context, int index) {
    if (list != null)
      return InkWell(
//          onTap: () {
//            if (Constants.token == null || Constants.token.length == 0)
//              RouteUtil.route2Login(context);
//            else
//              RouteUtil.route2ChargingReady(context, list[index].code);
//          },
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: Row(children: <Widget>[
                  Container(child: Image.asset('img/kuai_icon.png')),
                  Container(margin: EdgeInsets.symmetric(horizontal: 10), color: GlobalConfig.lineColor, width: 1, height: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${list[index]?.code}', style: TextStyle(fontSize: 18)),
                      Row(
                        children: <Widget>[
                          Text('站内编号${list[index]?.stationGunNo} '),
                          Text('| ' + (list[index].gunType == 0 ? '快充' : '慢充'), style: TextStyle(color: GlobalConfig.fontFreeColor))
                        ],
                      ),
                    ],
                  )),
                  Container(
                      color: list[index]?.status == 1 ? GlobalConfig.gunRedColor : GlobalConfig.gunGreenColor,
                      width: 40,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 1),
                      alignment: Alignment.center,
                      child: Text(list[index]?.status == 1 ? '忙' : '空闲', style: TextStyle(color: Colors.white))
                  )
                ]),
              ),
              new Divider()
            ],
          )
      );
  }

  Widget swiper() {
    return new Container(
      height: 200,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(images[index], fit: BoxFit.fill,);
        },
        autoplay: true,
        itemCount: images.length,
        pagination: new SwiperPagination(
            builder: new SwiperCustomPagination(
                builder: (BuildContext context, SwiperPluginConfig config) {
                  return new ConstrainedBox(
                    child: new Align(
                      alignment: Alignment.center,
                      child: new DotSwiperPaginationBuilder(color: GlobalConfig.bgColor, activeColor: Colors.white, size: 5.0, activeSize: 5.0).build(context, config)
                    ),
            constraints: new BoxConstraints.expand(height: 50.0),
          );
        })),
      ),
    );
  }

  Widget station() {
    return new Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(child: Container(alignment: Alignment.centerLeft, child: Text('${stationDetail?.name}', style: TextStyle(fontSize: 16)))),
              Container(margin: EdgeInsets.only(top: 5.0)),
              InkWell(child: Row(
                  children: <Widget>[
                    Text('${stationDetail?.operateTypeName}', style: TextStyle(color: Colors.yellow, fontSize: 12)),
                    Container(margin: EdgeInsets.only(left: 40.0)),
                    Text('运行时间 ${stationDetail?.operTime}', style: TextStyle(fontSize: 12))
                  ])
              ),
              Container(margin: EdgeInsets.only(top: 5.0)),
              InkWell(
                child: Row(
                  children: <Widget>[
                    InkWell(child: Image.asset('img/kuai_icon.png')),
                    Column(
                      children: <Widget>[
                        InkWell(child: Text('快充桩', style: TextStyle(color: Colors.black26))),
                        InkWell(child: Text('${stationDetail?.fastPoleCount}/${stationDetail?.fastPoleIdleCount}', style: TextStyle(color: Colors.black))),
                      ],
                    ),
                    Container(margin: EdgeInsets.only(left: 20.0)),
                    InkWell(child: Image.asset('img/man_icon.png')),
                    Column(children: <Widget>[
                      InkWell(child: Text('慢充桩', style: TextStyle(color: Colors.black26))),
                      InkWell(child: Text('${stationDetail?.slowPoleCount}/${stationDetail?.slowPoleIdleCount}', style: TextStyle(color: Colors.black)))
                    ])
                  ],
                ),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text('站点位置  ', style: TextStyle(color: GlobalConfig.fontFreeColor)),
                  Expanded(child: Text('${stationDetail?.address}', maxLines: 2)),
                  InkWell(
                    child: Column(
                      children: <Widget>[
                        Image.asset('img/location_icon.png'),
                        Text('立即前往', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    onTap: (){
                      AMapNavi().startNavi(lat: double.parse(widget.station.lat), lon: double.parse(widget.station.lng));
                    },
                  )
                ],
              ),
            ],
          )
      ),
    );
  }

  void _loadData() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.stationDetail, data: {
        "id": widget.station.id,
        "lat": widget.station.lat,
        "lng": widget.station.lng
      });
      if (response.statusCode == HttpStatus.ok) {
        setState(() {
          stationDetail = new StationModel.fromJson(response.data['data']);
          images = stationDetail?.images.split(',');
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void guns(final id) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(
          Apis.guns,
          data: {'stationId': id},
          options: new Options(contentType: ContentType.parse("application/x-www-form-urlencoded"))
      );

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data["data"];
        setState(() {
          list = tl.map((m) {
            return new GunsModel.fromJson(m);
          }).toList();
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    guns(widget.station.id);
  }
}
