import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../android_back_desktop.dart';
import '../global.dart';
import '../profile_model.dart';
import '../route/router.dart';
import "dart:math";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProfileModel get _profileModel => Global.profile;
  Timer? _timer;
  late int durationMilliseconds = 100; //循环间隔
  late int count; //循环次数
  double sliderValue1 = 20.0;
  double sliderValue2 = 100.0;

  String get name => _profileModel.appName ?? "APP Name";
  final random = Random();
  String keyName = "点击按钮开始";

  @override
  void initState() {
    super.initState();

    count = sliderValue1.toInt();
    durationMilliseconds = sliderValue2.toInt();
  }

  void startLoading() {
    if (_profileModel.jsonData?.isEmpty ?? true) {
       final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('数据被清空了吗？去添加数据再开始吧'),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: '知道了',
          onPressed: () {
            //Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: durationMilliseconds), (timer) {
      setState(() {
        count--;
        if (count > 0) {
          keyName = _profileModel
              .jsonData![random.nextInt(_profileModel.jsonData!.length)];
        } else {
          if (_profileModel.selectedItem?.isNotEmpty ?? false) {
            if (_profileModel.jsonData!.contains(_profileModel.selectedItem)) {
              keyName = _profileModel.selectedItem!;
            } else {
              keyName = _profileModel
                  .jsonData![random.nextInt(_profileModel.jsonData!.length)];
            }
          } else {
            keyName = _profileModel
                .jsonData![random.nextInt(_profileModel.jsonData!.length)];
          }
          timer.cancel();
          _timer = null;
          count = sliderValue1.toInt();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            AndroidBackTop.backDeskTop();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(name),
              actions: [
                IconButton(
                    onPressed: () {
                      context.goNamed(setting);
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                startLoading();
              },
              child: const Icon(Icons.restart_alt_outlined),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Center(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      keyName,
                      style: TextStyle(
                          fontSize: 50.0.sp,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Slider(
                    max: 50,
                    divisions: 10,
                    value: sliderValue1,
                    label: sliderValue1.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        sliderValue1 = value;
                        count = sliderValue1.toInt();
                      });
                    },
                  ),
                  Text("随机次数：${sliderValue1.toInt()}"),
                  SizedBox(
                    height: 25.0.h,
                  ),
                  Slider(
                    max: 500,
                    divisions: 5,
                    value: sliderValue2,
                    label: sliderValue2.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        sliderValue2 = value;
                        durationMilliseconds = sliderValue2.toInt();
                      });
                    },
                  ),
                  Text("循环间隔（毫秒）：${sliderValue2.toInt()}"),
                  SizedBox(
                    height: 50.0.h,
                  ),
                ],
              ),
            )));
  }
}
