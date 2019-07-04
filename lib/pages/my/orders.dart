import 'dart:async';
import 'dart:io';
import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/order_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * 订单
 */
class Orders extends StatefulWidget {
  @override
  _Orders createState() => new _Orders();
}

class _Orders extends State<Orders> {
  RefreshController _refreshController;
  List<OrderModel> listOrders = [];
  int page = 1;
  int pageSize = 10;

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

  void _onOffsetCallback(bool isUp, double offset) {

    // if you want change some widgets state ,you should rewrite the callback
  }

  @override
  void initState() {
    // TODO: implement initState
    _getOrders();
    _refreshController = new RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('充电订单'),
        centerTitle: true, // 居中
        elevation: 0,
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          color: GlobalConfig.bgColor,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            headerBuilder: (context, mode) {
              return ClassicIndicator(
                mode: mode,
                height: 45.0,
                releaseText: '松开手刷新',
                refreshingText: '刷新中',
                completeText: '刷新完成',
                failedText: '刷新失败',
                idleText: '下拉刷新'
            );},
            footerBuilder:(context, mode) {
              return ClassicIndicator(
                mode: mode,
                height: 45.0,
                releaseText: '松开手刷新',
                refreshingText: '刷新中',
                completeText: '刷新完成',
                failedText: '刷新失败',
                idleText: '上拉加载',
            );},
            controller: _refreshController,
            onRefresh: (up) async {
              if (up) {
                await new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
//                  _refreshController.scrollTo(_refreshController.scrollController.offset + 100.0);
                  _refreshController.sendBack(true, RefreshStatus.completed);
                  setState(() {
                    page = 1;
                    listOrders = [];
                  });
                });
              } else {
                await new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
                  _refreshController.sendBack(false, RefreshStatus.idle);
                  setState(() {
                    page = page + 1;
                  });

                });
              }
              _getOrders();
              },
              onOffsetChange: _onOffsetCallback,
              child: new ListView.builder(
                physics: new BouncingScrollPhysics(),
                reverse: true,
                itemCount: listOrders.length,
                itemBuilder: (context, index) => _item(index),
              ),
          ),
      ),
    );
  }

  Widget _item(final index) {
    if (listOrders != null)
      return new Container(
//        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: Colors.white,
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              alignment: Alignment.centerLeft,
              child: Text("订单编号：${listOrders[index].orderNo}", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Text("充电站 ：   ${listOrders[index].stationName}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Text("充电桩：    ${listOrders[index].gunCode}", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Text("充电量：    ${listOrders[index].chargedKw}", style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Text("充电时长：${listOrders[index].chargedTime}", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "充电时间：${
                    listOrders[index].startTime != null && listOrders[index].startTime.length > 16 ? listOrders[index].startTime.substring(0, 16)
                        : listOrders[index].startTime != null ? "" : listOrders[index].startTime}至${
                    listOrders[index].endTime != null && listOrders[index].endTime.length > 16 ? listOrders[index].endTime.substring(0, 16)
                        : listOrders[index].endTime != null ? "" : listOrders[index].endTime}",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5,bottom: 15),
              alignment: Alignment.centerRight,
              child: Text("￥${listOrders[index].cost}", style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
  }

  void _getOrders() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.orders, data: {'page': page, 'pageSize': pageSize});
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        List tl = response.data['data']['data'];
        setState(() {
          listOrders.addAll(tl.map((m) => OrderModel.fromJson(m)).toList());
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }
}
