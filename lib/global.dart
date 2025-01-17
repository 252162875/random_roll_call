import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_model.dart';

Logger logger = Logger();
const _themes = Colors.primaries;
class Global {
  static SharedPreferences? _preferences;
  static bool isBackFromThirdParty = false;

  static ProfileModel profile = ProfileModel(0, [],null,null);

  //可选的主题列表
  static List<MaterialColor> get themes => _themes;


// 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

//初始化全局信息，会在APP启动时执行
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    var pf = _preferences?.getString("profile");
    if (pf != null) {
      try {
        profile = ProfileModel.fromJson(jsonDecode(pf));
      } catch (e) {
        logger.e(e);
      }
    }
  }

  static saveProfile() {
    if (_preferences == null) {
    } else {
      _preferences!.setString("profile", jsonEncode(profile.toJson()));
    }
  }
}
