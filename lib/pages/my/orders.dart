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
  RefreshController _refreshController= RefreshController();
  List<OrderModel> listOrders = [];
  int page = 1;

  @override
  void initState() {
    _getOrders(true);
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
          child: RefreshConfiguration(
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
                  listOrders = [];
                  _getOrders(true);
                },
                onLoading: (){
                  page = page + 1;
                  _refreshController.isLoading;
                  _getOrders(false);
                },
                child: _listview()
            ),
          )
      ),
    );
  }

  Widget _listview() {
    return ListView.builder(
      itemCount: listOrders.length,
      physics: new BouncingScrollPhysics(),
      itemBuilder: (context, index) => _item(index),
    );
  }

  Widget _item(final index) {
    if (listOrders != null)
      return new Container(
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
              child: Text("充电时间：${
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

  //isDown是否是下拉操作
  void _getOrders(bool isDown) async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.orders, data: {'page': page, 'pageSize': 10});
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
