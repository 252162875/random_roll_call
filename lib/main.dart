import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:random_roll_call/profile_change_notifier.dart';
import 'global.dart';
import 'route/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  Global.init().then((e) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeChangeNotifier()),
        ],
        child: Consumer<ThemeChangeNotifier>(builder:
            (context, themeChangeNotifier, child) {
          return MaterialApp.router(
            routerConfig: router,
            theme: themeChangeNotifier.themeData(),
            themeMode: ThemeMode.system,
            darkTheme: themeChangeNotifier.themeData(platformDarkMode: true),
          );
        }),
      ),
    );
  }
}
