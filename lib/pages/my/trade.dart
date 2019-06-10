import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/trade_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * 交易明细
 */
class Trade extends StatefulWidget {
  @override
  _Trade createState() => new _Trade();
}

class _Trade extends State<Trade> {
  RefreshController _refreshController;
  int page = 1;
  int pageSize = 20;
  List<TradeModel> listTrade = [];

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
  }

  @override
  void initState() {
    _refreshController = new RefreshController();
    _getTrade();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('交易明细'),
        centerTitle: true, // 居中
        elevation: 1,
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        color: GlobalConfig.bgColor,
        child: new SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          enableOverScroll: false,
          footerBuilder: (context, mode) {
            return new ClassicIndicator(mode: mode);
          },
          footerConfig: new LoadConfig(triggerDistance: 30.0),
          onRefresh: (up) {
            if (up)
              new Future.delayed(const Duration(milliseconds: 2009))
                  .then((val) {
                _refreshController.scrollTo(_refreshController.scrollController.offset + 100.0);
                _refreshController.sendBack(true, RefreshStatus.idle);
                setState(() {
                  page = 1;
                  listTrade = [];
                  _getTrade();
                });
              });
            else {
              new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
                setState(() {
                  page = page + 1;
                  _getTrade();
                });
                _refreshController.sendBack(false, RefreshStatus.idle);
              });
            }
          },
          onOffsetChange: _onOffsetCallback,
          child: new ListView.builder(
            reverse: true,
            itemCount: listTrade.length,
            itemBuilder: (context, index) => _item(index),
          ),
        ),
      ),
    );
  }

  Widget _item(final index) {
    if (listTrade != null)
      return new Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${listTrade[index]?.tradeTime}', style: TextStyle(color: Colors.black26, fontSize: 12)),
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('${listTrade[index]?.title}', style: TextStyle(color: Colors.black, fontSize: 16))),
                        ],
                      ),
                    ),
                    Text('${listTrade[index]?.cost}元', style: TextStyle(color: listTrade[index]?.cost.contains('+') ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Divider(
                height: 1,
              )
            ],
          ));
//      return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
//        new Padding(
//            padding: EdgeInsets.only(bottom: 60),
//            child: MergeSemantics(
//                child: ListTile(
//              title: new Align(
//                alignment: Alignment.bottomLeft,
//                child: Text('${listTrade[index]?.tradeTime}',
//                    style: TextStyle(color: Colors.black26, fontSize: 12)),
//              ),
//              subtitle: new Align(
//                alignment: Alignment.topLeft,
//                child: Text('${listTrade[index]?.title}',
//                    style: TextStyle(color: Colors.black, fontSize: 16)),
//              ),
//              trailing: Text(
//                '${listTrade[index]?.cost}元',
//                style: TextStyle(
//                    color: listTrade[index]?.cost.contains('+')
//                        ? Colors.red
//                        : Colors.green),
//              ),
//            ))),
//        Divider()
//      ]);
  }

  void _getTrade() async {
    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio.post(Apis.trades, data: {'page': page, 'pageSize': pageSize});
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data['data']['data'];
        if (tl == null) {
          NativeUtils.showToast('暂无数据');
        } else {
          setState(() {
            listTrade.addAll(tl.map((m) {
              return new TradeModel.fromJson(m);
            }).toList());
          });
        }
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }
}
