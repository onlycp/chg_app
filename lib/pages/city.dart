import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/api/keyword_provider.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/city_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/**
 * 城市
 */
class City extends StatefulWidget {
  final cityName;
  City(this.cityName);
  @override
  _City createState() => new _City();
}

class _City extends State<City> {
  List<String> currentList = ["珠海"];
  List<String> hotList = [];
  List<CityModel> cityList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('当前城市'),
        leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        centerTitle: true, //
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              titleText("当前城市"),
              Container(
                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                height: 50.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: currentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _cityItem(currentList[index]);
                    }),
              ),
              titleText("最近访问城市"),
              Container(
                padding: EdgeInsets.only(left: 4.0, right: 4.0),
                height: 50.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _cityItem(hotList[index]);
                    }),
              ),
              titleText("所有城市"),
              Container(
//                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 350.0,
                child: GridView.count(
                  crossAxisCount: 3,
                  // 上下间隔
                  childAspectRatio: 2.4,
                  children: List.generate(cityList.length, (index) {
                    return _cityItem(cityList[index].name);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleText(final _name) {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          width: double.infinity,
          child: Text(_name, style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        );
      },
    );
  }

  Widget _cityItem(final name) {
    Color border = GlobalConfig.bgColor;
    Color color = Colors.black;
    if (name == widget.cityName) {
      border = Colors.lightBlue;
      color = Colors.lightBlue;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, name);
      },
      child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(border: Border.all(color: border, width: 1.0, style: BorderStyle.solid)),
            child: Chip(labelPadding: EdgeInsets.symmetric(horizontal: 8.0), label: Text(name, style: TextStyle(color: color,)), backgroundColor: Theme.of(context).primaryColor),
          )),
    );
  }

  void _loadData() async {
//    final Completer<Null> completer = new Completer<Null>();

//    _cityPresenter.city();

//    setState(() {});

//    completer.complete(null);
//    return completer.future;

    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio.post(Apis.operCities);

      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data["data"];
//        cityList = tl.map((model) {
//          return new CityModel.fromJson(model);
//        }).toList();
        setState(() {
          cityList.addAll(tl.map((model) {
            return new CityModel.fromJson(model);
          }).toList());
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _history() async {
    KeywordProvider keywordProvider = new KeywordProvider();
    await keywordProvider.open();

    List<Keyword> list = await keywordProvider.getKeywords(2);
    setState(() {
      hotList = list.map((m) {
        return m.title;
      }).toList();
    });
    await keywordProvider.close();
  }

  @override
  void initState() {
    super.initState();
    _history();
    _loadData();
  }
}
