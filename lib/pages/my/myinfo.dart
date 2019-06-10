import 'package:chp_app/api/apis.dart';
import 'package:chp_app/api/dio_factory.dart';
import 'package:chp_app/constants/Constants.dart';
import 'package:chp_app/constants/global_config.dart';
import 'package:chp_app/model/user_model.dart';
import 'package:chp_app/util/NativeUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

/**
 * 我的资料
 */
class MyInfo extends StatefulWidget {
  @override
  _MyInfo createState() => new _MyInfo();
}

class _MyInfo extends State<MyInfo> {
  UserModel userModel;
  List<String> images = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController idcardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('个人资料'),
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
        child:new ListView(
          children: <Widget>[
            myInfoCard()
          ],
        )
      ),
    );
  }

  Widget myInfoCard() {
    return new Container(
//      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: new Column(
        children: <Widget>[
//          _imageUploader(),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: new ListTile(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return new Container(
                      height: 180.0,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "相机",
                              textAlign: TextAlign.center,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              var image = await ImagePicker.pickImage(
                                  source: ImageSource.camera);
                              _upload(image.path);
                            },
                          ),
                          ListTile(
                            title: Text(
                              "相册",
                              textAlign: TextAlign.center,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              var image = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              _upload(image.path);
                            },
                          ),
                          ListTile(
                              title: Text(
                            "取消",
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                    );
                  },
                );
              },
              leading: Text(
                "个人头像",
              ),
              title: new Align(
                alignment: Alignment.centerRight,
                child: new CircleAvatar(
                    backgroundImage: new NetworkImage("${userModel?.photoUrl}"),
                    radius: 15.0),
              ),
              trailing: Image.asset('img/more_right.png'),
            ),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.symmetric(vertical: 1),
            child: new ListTile(
              leading: Text(
                "姓名",
              ),
              title: new Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${userModel?.realName}",
                ),
              ),
              trailing: Image.asset('img/more_right.png'),
            ),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.symmetric(vertical: 1),
            child: new ListTile(
              leading: Text(
                "手机号",
              ),
              title: new Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${userModel?.mobile}",
                ),
              ),
              trailing: Image.asset('img/more_right.png'),
            ),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.symmetric(vertical: 1),
            child: new ListTile(
              leading: Text(
                "实名验证",
              ),
              title: new Align(
                alignment: Alignment.centerRight,
                child: userModel?.isRealAuthed == 1
                    ? Text('${userModel?.realName}')
                    : TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: '请输入名字',
                          border: InputBorder.none,
                        ),
                        autofocus: false,
                      ),
              ),
//              trailing: Image.asset('img/more_right.png'),
            ),
          ),
          new Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10.0),
            margin: EdgeInsets.symmetric(vertical: 1),
            child: new ListTile(
              leading: Text(
                "身份证",
              ),
              title: new Align(
                alignment: Alignment.centerRight,
//                child: Text(
//                  "${userModel?.idCard}",
//                ),
                child: userModel?.isRealAuthed == 1
                    ? Text('${userModel?.idCard}')
                    : TextField(
                        controller: idcardController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: '请输入身份证',
                          border: InputBorder.none,
                        ),
                        autofocus: false,
                      ),
              ),
//              trailing: Image.asset('img/more_right.png'),
            ),
          ),
          new Container(child: submitButton(), margin: EdgeInsets.all(20))
        ],
      ),
    );
  }

  Widget submitButton() {
    return Offstage(
        offstage: userModel?.isRealAuthed == 1,
        child: StreamBuilder(
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
//            shape: StadiumBorder(),
                child: Text(
                  "修改",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  _upfateInfo();
                },
              ),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  void _getInfo() async {
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.info);
      if (response.statusCode == HttpStatus.ok) {
        setState(() {
          userModel = new UserModel.fromJson(response.data['data']);
        });
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  void _upfateInfo() async {
    if (nameController.text.length < 1 && idcardController.text.length < 1)
      NativeUtils.showToast('名字和身份证不能为空！');
//    userModel.idCard = idcardController.text;
//    userModel.realName = nameController.text;
    Dio dio = DioFactory.getInstance().getDio();
    try {
      Response response = await dio.post(Apis.updateInfo, data: {
        'realName': nameController.text,
        'idCard': idcardController.text
      });
      if (response.data['code'] == 0) {
        setState(() {
          userModel = new UserModel.fromJson(response.data['data']);
        });
      } NativeUtils.showToast(response.data['message']);
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }

  _upload(path) async {
    Dio dio = DioFactory.getInstance().getDio();

    final fileName = path.substring(path.lastIndexOf('/') + 1);
    try {
      FormData formData = new FormData.from(
          {"file": new UploadFileInfo(new File(path), fileName)});

      Response response = await dio.post(Apis.uploadPhoto, data: formData);
      if (response.statusCode == HttpStatus.ok && response.data['code'] == 0) {
        setState(() {});
      } else {
        NativeUtils.showToast(response.data['message']);
      }
    } catch (exception) {
      NativeUtils.showToast('您的网络似乎出了什么问题');
    }
  }
}
