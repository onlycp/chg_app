import 'dart:io';
import 'package:amap_base/amap_base.dart';
import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/api/keyword_provider.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/station_model.dart';
import 'package:chp_app/pages/city.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chp_app/events/LocationEvent.dart';
import 'package:chp_app/util/NetLoadingDialog.dart';

class ChargingScreen extends StatefulWidget {
  ChargingScreen();

  factory ChargingScreen.forDesignTime() => ChargingScreen();

  @override
  DrawPointScreenState createState() => new DrawPointScreenState();
}

class DrawPointScreenState extends State<ChargingScreen> {

  AMapController _controller;
  final _amapLocation = AMapLocation();
  UiSettings _uiSettings = UiSettings();
  final key = new GlobalKey<ScaffoldState>();
  String cityName = "";
  StationModel station;
  List<StationModel> cityList = [];
  bool isShowMarker = false;
  String barcode = "";
  LatLng curLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: barSearch(),
        body: Column(
          children: <Widget>[
            _head(),
            Expanded(child: amapView())
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatView());
  }

  Widget _head() {
    return new Container(
      padding: const EdgeInsets.only(top: 30.0),
      color: Colors.white,
      child: new Row(
        children: <Widget>[
          InkWell(
            child: Container(
                padding: EdgeInsets.all(20),
                child:Image.asset("img/people_icon.png"),
            ),
            onTap: _login,
          ),
          Expanded(
            child: Container(
              height: 30,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xFFF3F3F3)),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 3, right: 5),
                      child: Icon(Icons.search, color: Colors.grey, size: 16.0),
                    ),
                    Text('请输入充电站名称或地址', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                onTap: _search,
              ),
            ),
          ),
          InkWell(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Text('${cityName}'),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            onTap: _city,
          ),
        ],
      ),
    );
  }

  Widget amapView() {
    return Builder(
      builder: (context) {
        return Stack(
          children: <Widget>[
            AMapView(
              onAMapViewCreated: (controller) async {
                _controller = controller;
                controller.setZoomLevel(20);
                controller.setUiSettings(_uiSettings.copyWith(isZoomControlsEnabled: false));
                controller.setMyLocationStyle(MyLocationStyle(
                    showsAccuracyRing: true,
                    myLocationType: LOCATION_TYPE_SHOW,
                    showMyLocation: true,
                    interval: 10000,
                    radiusFillColor: Color.fromARGB(0, 0, 0, 0),
                    strokeWidth: 0,
                    image: 'img/location_icon.png')
                );
                controller.markerClickedEvent.listen((marker) {
                  setState(() {
                  station = cityList.firstWhere((m) => m.name == marker.title);
                    _getStation(station.id, station.lat, station.lng);
                    isShowMarker = !isShowMarker;
                  });
                });
              },
              amapOptions: AMapOptions(),
            ),
            scardView(),
          ],
        );
      },
    );
  }

  Widget floatView() {
    return new Container(
        height: 300,
        child: Column(
          children: <Widget>[
            leftButton(),
            rightButton(),
            scanButton(),
//            scardView()
          ],
        ));
  }

  Widget leftButton() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(bottom: 40),
        child: Column(children: <Widget>[
          InkWell(
            onTap: _location,
            child: Image.asset('img/car-h.png'),
          ),
          InkWell(
            onTap: _refresh,
            child: Image.asset('img/refresh.png'),
          )
        ]));
  }

  Widget rightButton() {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(bottom: 20, right: 10),
        child: Column(children: <Widget>[
          FloatingActionButton(
            onPressed: _watch,
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Image.asset('img/jiankong_icon.png'),
          ),
        ]));
  }

  Widget scanButton() {
    return Offstage(
      offstage: isShowMarker,
      child: Container(
        width: 135,
        height: 50,
        padding: EdgeInsets.all(2),
        child: new FlatButton(
          color: Colors.blue,
          shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset('img/scan.png'),
                ),
              ),
              InkWell(
                child: Text(
                  '扫码登录',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          onPressed: () {
            scan();
          },
        ),
      ),
    );
  }

  Widget scardView() {
    return Offstage(
      offstage: !isShowMarker,

      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: InkWell(
                onTap: (){
                  setState(() {
                    isShowMarker = false;
                    _controller.clearMarkers();
                    _controller.addMarkers(
                      cityList.map((m) => MarkerOptions(
                          icon: 'img/charger.png',
                          position: LatLng(double.tryParse(m.lat), double.tryParse(m.lng)), title: m.name)).toList(),
                    );
                  });
                }),
          ),
          infoView()
        ],
      ),
    );
  }

  Widget infoView() {
    return Container(
      height: 96,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 200, left: 8, right: 8),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${station?.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Text('${station?.operTime} | ${station?.address}', style: TextStyle(color: Colors.grey),),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          color: GlobalConfig.labelColor,
                          child: Text('${station?.operateTypeName}', style: TextStyle(color: GlobalConfig.fontLabelColor, fontSize: 12))),
                      Text(' | '),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: CircleAvatar(backgroundColor: GlobalConfig.fontLabelColor, radius: 3.0)),
                      Text('快充'),
                      Text('${station?.fastPoleCount}', style: TextStyle(color: Colors.black, fontSize: 20)),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: CircleAvatar(backgroundColor: Colors.blue, radius: 3.0)
                      ),
                      Text('慢充'),
                      Text('${station?.slowPoleCount}', style: TextStyle(color: Colors.black, fontSize: 20))
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              RouteUtil.route2StationDetail(context, station);
            },
            child: Row(
              children: <Widget>[
                InkWell(child: Text('详情')),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.asset('img/more.png'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _location() async {
    if(Platform.isIOS){

      AMapLocation().getLocation(new LocationClientOptions()).then((latlog) {
        if(cityName.length == 0) {
          AMapLocation().stopLocate();
          curLocation = new LatLng(latlog.latitude, latlog.longitude);
          AMapSearch().searchReGeocode(curLocation, 1000, 1).then((gr) {
            setState(() {
              cityName = gr.regeocodeAddress.city;
              _controller.changeLatLng(curLocation);
            });
          });
        }else {
          _controller.changeLatLng(new LatLng(latlog.latitude, latlog.longitude));
        }
      });
    }else {
      if(await NativeUtils.permission("android.permission.ACCESS_FINE_LOCATION", 300)){
        AMapLocation().getLocation(new LocationClientOptions()).then((latlog) {
          if(cityName.length == 0) {
            curLocation = new LatLng(latlog.latitude, latlog.longitude);
            AMapSearch().searchReGeocode(curLocation, 1000, 1).then((gr) {
              setState(() {
                cityName = gr.regeocodeAddress.city;
                _controller.changeLatLng(curLocation);
              });
            });
          }else {
            _controller.changeLatLng(new LatLng(latlog.latitude, latlog.longitude));
          }
        });
      }
    }
  }

  void _refresh() {
    if(cityName.length == 0){
      _location();
    }else{
      _stationOverview(cityName);
    }
  }

  void _watch() async {
    if (Constants.token == null || Constants.token.length == 0)
      RouteUtil.route2Login(context);
    else {
      Dio dio = DioFactory.getInstance().getDio();
      try {
        Response response = await dio.post(Apis.realInfo);

        if (response.statusCode == HttpStatus.ok &&
            response.data['code'] == 0) {
          if (response.data["data"] == null ||
              response.data["data"]['gunCode'] == null)
            NativeUtils.showToast('当前无充电订单');
          else
            RouteUtil.route2ChargingMonitor(context);
        } else {
          NativeUtils.showToast(response.data['message']);
        }
      } catch (exception) {
        NativeUtils.showToast('当前无充电订单');
      }
    }
  }

  Future scan() async {
    if (Constants.token == null || Constants.token.length == 0)
      RouteUtil.route2Login(context);
    else {
      String result = await NativeUtils.scanf();
//      String version = await NativeUtils.getSystemVersion();
      setState(() => this.barcode = result);
      showDialog(context: context, builder: (context) {
            return new NetLoadingDialog(loadingText: "正在扫码登陆中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
      });
    }
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.findPole,
//            data: {"code": result,"deviceType":Platform.isAndroid ? "0" : "1","system": Platform.isAndroid ? "Android" + version : "iOS" + version},
          data: {"code": barcode},
          options: new Options(contentType: ContentType.parse("application/x-www-form-urlencoded"))
      );

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          //充电状态（1：充电中，2：带充电）
          int chgStatus = response.data["data"]['chgStatus'];
          if (response.data["data"] != null && chgStatus == 1) {
            RouteUtil.route2ChargingMonitor(context);
          } else {
            RouteUtil.route2ChargingReady(context, barcode);
          }
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    } finally {
      Navigator.of(context).pop(true);
    }
  }

  void _login() {
    if (Constants.token == null || Constants.token.length == 0) {
      RouteUtil.route2Login(context);
    } else {
      RouteUtil.route2My(context);
    }
  }

  void _city() {
    Future future = Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return new City(cityName);
    }));
    future.then((name) {
      cityName = name == null ? cityName : name;
      _stationOverview(cityName);
    });
  }

  void _search() {
    RouteUtil.route2Search(context, new LocationEvent(cityName: cityName, latLng: curLocation));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didUpdateWidget(w) {
    super.didUpdateWidget(w);
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _amapLocation.init();
    _refresh();
  }



  void _keyword(String name) async {
    KeywordProvider keywordProvider = new KeywordProvider();
    await keywordProvider.open();
    Keyword keyword = Keyword()..title = name;
    keyword.sort = 2;
    keyword.dateTime = DateTime.now().millisecondsSinceEpoch;
    await keywordProvider.insert(keyword);
    await keywordProvider.close();
  }

  void _stationOverview(String name) async {
    if (name != null && name.length > 1) _keyword(name);
    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio.post(Apis.stationOverview,
          data: {"cityName": name},
          options: new Options(
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded")));

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data["data"];
        if (tl == null || tl.length == 0) {
          NativeUtils.showToast('${name}暂无充电站');
//        获取城市坐标
          AMapSearch().searchGeocode(name, name).then((gr) {
            setState(() {
              curLocation = LatLng(
                  gr.geocodeAddressList.single.latLng.latitude,
                  gr.geocodeAddressList.single.latLng.longitude);
              _controller.changeLatLng(curLocation);
            });
          });
        } else {
          setState(() {
            cityList.addAll(tl.map((m) {
              return new StationModel.fromJson(m);
            }).toList());
            if (cityList != null) {
              final nextLatLng = LatLng(double.tryParse(cityList[0].lat), double.tryParse(cityList[0].lng));
              _controller.changeLatLng(nextLatLng);
              _controller.setZoomLevel(20);
              _controller.addMarkers(
                cityList.map((m) => MarkerOptions(
                        icon: 'img/charger.png',
                        position: LatLng(double.tryParse(m.lat), double.tryParse(m.lng)), title: m.name)).toList(),
              );

            }
          });
        }
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

//站点详情
  void _getStation(String id, String lat, String lng) async {
    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio
          .post(Apis.stationDetail, data: {"id": id, "lat": lat, "lng": lng});

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {
          station = new StationModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> _getToken() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      Constants.token = prefs.getString('token');
      Constants.refreshToken = prefs.getString('refreshToken');
    });
  }
}
