import 'dart:async';
import 'dart:io';

import 'package:amap_base/amap_base.dart';
import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/api/keyword_provider.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/station_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/util/route_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/**
 * 充电站
 */
class ChargingSearch extends StatefulWidget {
  @override
  _ChargingSearch createState() => new _ChargingSearch();
}

class _ChargingSearch extends State<ChargingSearch> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  String cityName = "珠海";
  String keyword = "";
  double lng = 0.0;
  double lat = 0.0;
  int page = 1;
  int pageSize = 10;
  List<StationModel> stationList = [];

  TextEditingController _textField = TextEditingController();

  List<String> _selectableTags = [];
  bool _hiddeTag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _head(),
        elevation: 1,
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                _listView(),
//                _historyList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _head() {
    return new Row(
      children: <Widget>[
        Expanded(child: barSearch()),
        InkWell(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text('检索', style: TextStyle(fontSize: 16)),
          ),
          onTap: () {
            setState(() {
              _hiddeTag = true;
              _keyword(_textField.text);
              if (!_selectableTags.contains(_textField.text)) {
                _selectableTags.add(_textField.text);
              }
            });
          },
        ),
      ],
    );
  }

  Widget barSearch() {
    return Container(
      height: 35,
      child: Material(
        child: new TextField(
          onTap: (){
            _hiddeTag = false;
          },
          controller: _textField,
          onChanged: _textFieldChanged,
          style: new TextStyle(color: Colors.black, fontSize: 14),
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(top: 7),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 16),
            hintText: "请输入充电站名称或地址",
            border: InputBorder.none,
            hintStyle: new TextStyle(color: Colors.black38),
          ),
          obscureText: false,
        ),
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.grey,
      ),
    );
  }

  void _textFieldChanged(String str) {
    setState(() {
      _hiddeTag = !(str.length == 0);
      stationList.clear();
      keyword = _textField.text;
      _getStationQuery(cityName, keyword, lng, lat, page, pageSize);
    });
  }

  Widget _listView() {
    return RefreshIndicator(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: stationList?.length,
            itemBuilder: (context, index) =>
                _stationWidget(stationList[index])),
        onRefresh: _refreshData);
//    return Offstage(
//        offstage: !_hiddeTag,
//        child: RefreshIndicator(
//            child: ListView.builder(
//                controller: _scrollController,
//                itemCount: stationList?.length,
//                itemBuilder: (context, index) =>
//                    _stationWidget(stationList[index])),
//            onRefresh: _refreshData));
  }

  Widget _historyList() {
    return Container(
      color: Colors.white,
      child: Offstage(
        offstage: _hiddeTag,
        child: new ListView.builder(
          itemCount: _selectableTags.length,
          itemBuilder: (context, index) => _tagItem(index),
        ),
      ),
    );
  }

  Widget _stationWidget(StationModel station) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: <Widget>[
          new Expanded(
            child: InkWell(
              onTap: () {
                RouteUtil.route2StationDetail(context, station);
              },
//            child: Padding(padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(station.name,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left),
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(station.address,
                          style: TextStyle(color: GlobalConfig.fontFreeColor))),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: GlobalConfig.labelFastColor,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        child: Text('直流',
                            style:
                                TextStyle(color: GlobalConfig.labelFastColor)),
                      ),
                      Row(children: <Widget>[
                        Text('${station?.fastPoleCount}',
                            style:
                                TextStyle(color: GlobalConfig.labelFastColor)),
                        Text('/${station?.fastPoleIdleCount}')
                      ]),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        margin: EdgeInsets.only(left: 20, right: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: GlobalConfig.labelSlowColor,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        child: Text('交流',
                            style:
                                TextStyle(color: GlobalConfig.labelSlowColor)),
                      ),
                      Row(children: <Widget>[
                        Text('${station?.slowPoleCount}',
                            style:
                                TextStyle(color: GlobalConfig.labelSlowColor)),
                        Text('/${station?.slowPoleIdleCount}')
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: Row(children: <Widget>[
                    Text('${station.distance}m',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: GlobalConfig.fontFreeColor)),
                    Container(margin: EdgeInsets.only(left: 5)),
                    InkWell(
                      onTap: () {
                        AMapNavi().startNavi(
                            lat: double.tryParse(station.lat),
                            lon: double.tryParse(station.lng),
                            naviType: AMapNavi.ride);
                      },
                      child: Image.asset('img/location_icon.png'),
                    )
                  ])),
              Container(
                margin: EdgeInsets.only(bottom: 10.0, top: 5),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: station?.operateTypeName.endsWith("私人充电站")
                      ? Color(0xFFD3F2BE)
                      : Color(0xFFFFF1CE),
                ),
                child: Text('${station?.operateTypeName}',
                    style: TextStyle(
                        color: station?.operateTypeName.endsWith("私人充电站")
                            ? Color(0xFF69BC11)
                            : GlobalConfig.fontLabelColor,
                        fontSize: 12)),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: Row(children: <Widget>[
                    Text('停车费',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: GlobalConfig.fontFreeColor, fontSize: 14)),
                    Text('￥10.0',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: GlobalConfig.fontLabelColor, fontSize: 16))
                  ])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagItem(final index) {
    if (index == 0) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 10, left: 20),
        child: Row(
          children: <Widget>[
            Text(_selectableTags[index], style: TextStyle(fontSize: 20)),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: InkWell(
                    child: Offstage(
                      offstage: _selectableTags.length == 1,
                      child: Text("清除",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                    onTap: () {
                      setState(() {
                        _selectableTags.clear();
                        _selectableTags.add("搜索历史");
                        _clean_keyword();
                      });
                    }),
              ),
            ),
          ],
        ),
      );
    }
    return new InkWell(
      child: Column(
        children: <Widget>[
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
            child: Text(_selectableTags[index],
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          _textField = TextEditingController.fromValue(TextEditingValue(
              text: _selectableTags[index],
              selection: TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: _selectableTags[index].length))));
          _hiddeTag = !(_textField.text.length == 0);
          stationList.clear();
          keyword = _textField.text;
          _getStationQuery(cityName, keyword, lng, lat, page, pageSize);
        });
      },
    );
  }

  Widget itemView() {
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

  Future<Null> _refreshData() {
    page = 1;
    stationList.clear();
    final Completer<Null> completer = new Completer<Null>();
    _getStationQuery(cityName, keyword, lng, lat, page, pageSize);
    setState(() {});
    completer.complete(null);
    return completer.future;
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();
    _getStationQuery(cityName, keyword, lng, lat, page, pageSize);
    setState(() {});
    completer.complete(null);
    return completer.future;
  }

  void _keyword(String name) async {
    KeywordProvider keywordProvider = new KeywordProvider();
    await keywordProvider.open();
    Keyword keyword = Keyword()..title = name;
    keyword.sort = 1;
    keyword.dateTime = DateTime.now().millisecondsSinceEpoch;
    await keywordProvider.insert(keyword);
    await keywordProvider.close();
  }

  void _clean_keyword() async {
    KeywordProvider keywordProvider = new KeywordProvider();
    await keywordProvider.open();
    await keywordProvider.delete(1);
    await keywordProvider.close();
  }

  void _history() async {
    KeywordProvider keywordProvider = new KeywordProvider();
    await keywordProvider.open();
    _selectableTags.add("搜索历史");
    List<Keyword> list = (await keywordProvider.getKeywords(1));
    list.forEach((item) {
      _selectableTags.add(item.title);
    });
    setState(() {});
    await keywordProvider.close();
  }

//站点列表
  void _getStationQuery(String cityName, String keyword, double lng, double lat,
      int page, int pageSize) async {
    if (cityName != null && cityName.length > 1) _keyword(cityName);

    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.stationListQuery, data: {
        "cityName": cityName,
        "keyword": keyword,
        "lng": lng,
        "lat": lat,
        "page": page,
        "pageSize": pageSize,
      });

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data["data"]["data"];
        if (tl == null) {
          NativeUtils.showToast('暂无更多数据');
        } else {
          setState(() {
            stationList.addAll(tl.map((m) {
              return new StationModel.fromJson(m);
            }).toList());
//            for(int i = 0; i < 10; i++) {
//            }
          });
        }
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
//    _history();
    _hiddeTag = true;
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page += 1;
        _loadData();
      }
    });
  }
}
