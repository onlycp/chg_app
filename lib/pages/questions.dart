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

  void enterRefresh() {
    _refreshController.requestRefresh(true);
  }

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
//        color: GlobalConfig.bgColor,
        child: SimpleFoldingCell(
            key: _foldingCellKey,
            frontWidget: _buildFrontWidget(),
            innerTopWidget: _buildInnerTopWidget(),
            innerBottomWidget: _buildInnerBottomWidget(),
            cellSize: Size(MediaQuery.of(context).size.width, 125),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 10,
            onOpen: () => print('cell opened'),
            onClose: () => print('cell closed')),
      ),
//        child: SingleChildScrollView(
//          child: ExpansionPanelList(
//            children: listQuestions.map((model) {
//              return ExpansionPanel(
//                isExpanded: (model == null ? false : model.select),
//                headerBuilder: (content, opened) {
//                  return ListTile(
//                      title: Text('${model?.question}')
//                  );
//                },
//                body: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Padding(
//                        padding: EdgeInsets.symmetric(horizontal: 10.0),
//                        child: Divider(),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(left: 15.0, right: 10, bottom: 10),
//                        alignment: Alignment.centerLeft,
//                        child: Text(model.answer, style: TextStyle(color: Colors.black45)),
//                      ),
//                    ]),
//              );
//            }).toList(),
//            expansionCallback: (index, bol) {
//              setState(() {
//                if (listQuestions[index] != null)
//                  listQuestions[index].select = !listQuestions[index].select;
//              });
//            },
//          ),
//        ),
//      ),
    );
  }

  Widget _buildFrontWidget() {
    return InkWell(
        onTap: () => _foldingCellKey?.currentState?.toggleFold(),
        child: Container(
          child: Text("titlesss"),
          alignment: Alignment.center,
          color: Color(0xFFffcd3c),

        )
    );
  }

  Widget _buildInnerTopWidget() {
    return Container(
        color: Color(0xFFff9234),
        alignment: Alignment.center,
        child: Text("TITLE",
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'OpenSans',
                fontSize: 20.0,
                fontWeight: FontWeight.w800)));
  }

  Widget _buildInnerBottomWidget() {
    return InkWell(
        onTap: () => _foldingCellKey?.currentState?.toggleFold(),
        child: Container(
          child: Text("titlessssadadas"),
          alignment: Alignment.center,
          color: Color(0xFFffcd3c),

        )
    );
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
