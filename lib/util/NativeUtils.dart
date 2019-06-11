import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeUtils {
  static const String CHANNEL = "com.che.native";

  static MethodChannel _channel = const MethodChannel(CHANNEL);

  static callPhoneNumber(BuildContext context, String number) {
    _channel.invokeMethod('callPhone', number);
  }

  static void showToast(String content) {
    _channel.invokeMethod('showToast', content);
  }

  static tabBarColor() {
    if(Platform.isAndroid) {
      _channel.invokeMethod('tabBarColor');
    }
  }

  static downloadApp(String url) {
    _channel.invokeMethod('downloadApp', {"url":url});
  }

  static Future<bool> permission(String permission, int permissionCode) async {
    return await _channel.invokeMethod('permission', {"permission":permission, "permissionCode":permissionCode});
  }

  static Future<String> scanf() async {
    return await _channel.invokeMethod('scanf');
  }

  static Future<int> getVersion() async {
    return await _channel.invokeMethod('getVersion');
  }

  static Future<String> getSystemVersion() async {
    return await _channel.invokeMethod('getSystemVersion');
  }

  static Future<String> encrypt(String txt, String publicKey) async {
    try {
      final String result = await _channel.invokeMethod('encrypt', {"txt": txt, "publicKey": publicKey});
      return result;
    } on PlatformException catch (e) {
      throw "Failed to get string encoded: '${e.message}'.";
    }
  }
}
