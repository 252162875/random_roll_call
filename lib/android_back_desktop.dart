import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AndroidBackTop {
  static const String CHANNEL = "android/back/desktop";
  static const String CHANNEL_CAN_NOT_BACK = "android/canNotBack/desktop";

  static Future<bool> backDeskTop() async {
    const platform = MethodChannel(CHANNEL);
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('BackTop');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(false);
  }

  static Future<bool> canNotBack(bool canNotBack) async {
    const platform = MethodChannel(CHANNEL_CAN_NOT_BACK);
    try {
      final bool out = await platform.invokeMethod('canNotBack',{"canNotBack":canNotBack});
      if (out) debugPrint('canNotBack');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(false);
  }
}
