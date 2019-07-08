import 'dart:io';

import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:chp_app/widgets/image_wall.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chp_app/cfg.dart';
import 'package:chp_app/util/NetLoadingDialog.dart';

/**
 * 问题反馈
 */
class Ask extends StatefulWidget {
  @override
  _Ask createState() => new _Ask();
}

class _Ask extends State<Ask> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('问题反馈'),
        centerTitle: true, // 居中
        leading: InkWell(
          child: Image.asset("img/back_left.png"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: GlobalConfig.bgColor,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            stationShow(),
            Container(margin: EdgeInsets.only(top: 20.0)),
            askField(),
          ],
        ),
      ),
    );
  }

  Widget stationShow() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0), color: Colors.white),
      child: ListTile(
        title: Text('当前充电站', style: TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text('当前充电站', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        trailing: Image.asset('img/more_right.png'),
      ),
    );
  }

  Widget askField() {
    return Expanded(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0), color: Colors.white),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 1,
                        color: GlobalConfig.lineColor,
                        margin: EdgeInsets.only(right: 10)


                      ),
                    ),
                    Text("问题描述", style: TextStyle(color: GlobalConfig.lineColor)),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: GlobalConfig.lineColor,
                        margin: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: '请您输入详细问题描述',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
                maxLines: 5,
                autofocus: false,
              ),
              _imageUploader(),
              submitButton()
            ],
          )),
    );
  }

  Widget _imageUploader() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 20),
      child: SyImageWall(
          reorderable: false,
          images: images,
          onChange: (images) {
            print(images);
          },
          onUpload: () async {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return new Container(
                  height: 180.0,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("相机", textAlign: TextAlign.center),
                        onTap: () async {
                          Navigator.pop(context);
                          var image = await ImagePicker.pickImage(source: ImageSource.camera);
                          setState(() {
                            images.add(image.path);
                          });
                        },
                      ),
                      ListTile(
                        title: Text("相册", textAlign: TextAlign.center),
                        onTap: () async {
                          Navigator.pop(context);
                          var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          setState(() {
                            images.add(image.path);
                          });
                        },
                      ),
                      ListTile(title: Text("取消", textAlign: TextAlign.center)),
                    ],
                  ),
                );
              },
            );
          }),
    ));
  }

  Widget submitButton() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.only(top: 20),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
//            shape: StadiumBorder(),
            child: Text("提交", style: TextStyle(color: Colors.white, fontSize: Cfg.FONT_SIZE_CELL_TITLE)),
            color: Colors.blue,
            onPressed: _submitButtonPressed,
          ),
        );
      },
    );
  }

  void _submitButtonPressed() async {
    showDialog(context: context, builder: (context) {
      return new NetLoadingDialog(loadingText: "正在加载中...", dismissDialog: _disMissCallBack, outsideDismiss: true);
    });
  }

  _disMissCallBack(Function fun) async {
    Dio dio = DioFactory.getInstance().getDio();

    List imageFile = [];
    for (String path in images) {
      imageFile.add(File(path));
    }
    FormData formData = new FormData.from(
        {"content": phoneController.text, "files": imageFile});
    try {
      Response response = await dio.post(Apis.submitFeeback, data: formData);
      if (response.statusCode == HttpStatus.ok) {
        NativeUtils.showToast(response.data['message']);
        Navigator.pop(context);
      } else {
        throw '服务器异常';
      }
    } catch (exception) {
      throw '您的网络似乎出了什么问题';
    } finally {
      Navigator.pop(context);
    }
  }
}
