import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chp_app/api/apis.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
        color: GlobalConfig.bgColor,
        child: SingleChildScrollView(
          child: ExpansionPanelList(
            children: listQuestions.map((model) {
              return ExpansionPanel(
                isExpanded: (model == null ? false : model.select),
                headerBuilder: (content, opened) {
                  return ListTile(
                      title: Text('${model?.question}')
                  );
                },
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15.0, right: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(model.answer, style: TextStyle(color: Colors.black45)),
                      ),
                    ]),
              );
            }).toList(),
            expansionCallback: (index, bol) {
              setState(() {
                if (listQuestions[index] != null)
                  listQuestions[index].select = !listQuestions[index].select;
              });
            },
          ),
        ),
      ),
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
