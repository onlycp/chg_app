import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chp_app/api/apis.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folding_cell/folding_cell.dart';
import 'dart:io';

/**
 * 常见问题
 */
class Questions extends StatefulWidget {

  @override
  _Questions createState() => new _Questions();
}

class _Questions extends State<Questions> {

  RefreshController _refreshController;
  int page = 1;
  int pageSize = 10;
  List<QuestionModel> listQuestions = [];

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
  }

  @override
  void initState() {
    _refreshController = new RefreshController();
    _getQuestion();
    super.initState();
  }

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('常见问题'),
        centerTitle: true,
        elevation: 1,
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ), // 居中
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: listQuestions.length,
            itemBuilder: (BuildContext context, int index) {
              return SimpleFoldingCell(
                  frontWidget: _buildFrontWidget(listQuestions[index]),
                  innerTopWidget: _buildInnerTopWidget(listQuestions[index]),
                  innerBottomWidget: _buildInnerBottomWidget(listQuestions[index]),
                  cellSize: Size(MediaQuery.of(context).size.width, 60),
                  padding: EdgeInsets.all(15),
                  animationDuration: Duration(milliseconds: 300),
              );
            }
        )
      )
    );
  }

  Widget _buildFrontWidget(QuestionModel model) {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
            child: Container(
              color: Color(0xFFffcd3c),
              alignment: Alignment.center,
              child: Text(model.question, style: TextStyle(color: Color(0xFF2e282a), fontFamily: 'OpenSans', fontSize: 20.0, fontWeight: FontWeight.w500)),
            ),
          onTap: () {
            SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
            foldingCellState?.toggleFold();
          },
        );
      },
    );
  }

  Widget _buildInnerTopWidget(QuestionModel model) {
    return InkWell(
        child: Container(
          color: Color(0xFFffcd3c),
          alignment: Alignment.center,
          child:   Text(model.question, style: TextStyle(color: Color(0xFF2e282a), fontFamily: 'OpenSans', fontSize: 20.0, fontWeight: FontWeight.w500)),
        ),
        onTap: () {
          SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
          foldingCellState?.toggleFold();
        },
    );
  }

  Widget _buildInnerBottomWidget(QuestionModel model) {
    return Builder(builder: (context) {
      return InkWell(
        child: Container(color: Color(0xFFecf2f9), alignment: Alignment.center, child: Text(model.answer)),
        onTap:  () {
          SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
          foldingCellState?.toggleFold();
        },
      );
    });
  }

  void _getQuestion() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.questions);
      if (response.statusCode == HttpStatus.ok) {
        List tl = response.data['data'];
        setState(() {
          listQuestions.addAll(tl.map((m) => QuestionModel.fromJson(m)).toList());
        });
      } else {
        throw '服务器异常';
      }
    } catch (exception) {
      throw '您的网络似乎出了什么问题';
    }
  }
}
