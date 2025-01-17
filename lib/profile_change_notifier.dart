import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_roll_call/profile_model.dart';

import 'global.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  ProfileModel get _profileModel => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class ThemeChangeNotifier extends ProfileChangeNotifier {
  MaterialColor get theme =>
      Global.themes.firstWhere((e) => e.value == _profileModel.theme,
          orElse: () => Colors.blue);

  set theme(MaterialColor theme) {
    if (this.theme != theme) {
      _profileModel.theme = theme.value;
      notifyListeners();
    }
  }


  themeData({bool platformDarkMode = false}) {
    logger.e("profileModel.theme = ${_profileModel.theme}");
    Brightness brightness =
    platformDarkMode ? Brightness.dark : Brightness.light;
    var themeData = ThemeData(
        brightness: brightness,
        useMaterial3: true,
        colorSchemeSeed: theme,
        appBarTheme: AppBarTheme(
            backgroundColor: brightness ==Brightness.dark  ? theme.shade700 : theme.shade400,
            centerTitle: true,
            systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: brightness)),
        navigationBarTheme: NavigationBarThemeData(
            indicatorColor:
            brightness ==Brightness.dark ? theme.shade700 : theme.shade400));
    return themeData;
  }
}
