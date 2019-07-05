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
  RefreshController _refreshController= RefreshController(initialRefresh:true);
  int page = 1;
  List<TradeModel> listTrade = [];

  @override
  void initState() {
    _refreshController = new RefreshController();
    _getTrade(true);
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
        child:RefreshConfiguration(
          hideFooterWhenNotFull: false,
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: Platform.isIOS ? WaterDropHeader() : WaterDropMaterialHeader(),
              footer: ClassicFooter(
                  height: 45,
                  idleText:"上拉加载",
                  loadingText:"加载中",
                  failedText:"加载失败",
                  noDataText: "没有数据"
              ),
              controller: _refreshController,
              onRefresh: (){
                page = 1;
                listTrade = [];
                _getTrade(true);
              },
              onLoading: (){
                page = page + 1;
                _refreshController.isLoading;
                _getTrade(false);
              },
              child: _listview()
        ),)
      ),
    );
  }

  Widget _listview() {
    return ListView.builder(
      itemCount: listTrade.length,
      physics: new BouncingScrollPhysics(),
      itemBuilder: (context, index) => _item(index),
    );
  }

  Widget _item(final index) {
    if (listTrade != null)
      return new Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${listTrade[index]?.tradeTime}', style: TextStyle(color: Colors.black26, fontSize: 12)),
                          Container(padding: EdgeInsets.only(top: 10), child: Text('${listTrade[index]?.title}', style: TextStyle(color: Colors.black, fontSize: 16))),
                        ],
                      ),
                    ),
                    Text('${listTrade[index]?.cost}元', style: TextStyle(color: listTrade[index]?.cost.contains('+') ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Divider(height: 1)
            ],
          )
      );
  }

  //isDown是否是下拉操作
  void _getTrade(bool isDown) async {
    Dio dio = DioFactory.getInstance().getDio();

    try {
      Response response = await dio.post(Apis.trades, data: {'page': page, 'pageSize': 10});
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
    }finally{
      if(isDown) {
        _refreshController.refreshCompleted();
      }else{
        _refreshController.loadComplete();
      }
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
