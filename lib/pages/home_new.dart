import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../android_back_desktop.dart';
import '../global.dart';
import '../profile_model.dart';
import '../route/router.dart';
import "dart:math";

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({super.key});

  @override
  State<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> {
  ProfileModel get _profileModel => Global.profile;
  Timer? _timer;
  late int durationMilliseconds = 100; //循环间隔
  late double textSize = 100.0; //字体大小
  late int count; //循环次数
  double sliderValue1 = 20.0;
  double sliderValue2 = 100.0;
  double sliderValue3 = 100.0;

  String get name => _profileModel.appName ?? "APP Name";
  final random = Random();
  String keyName = "点击按钮开始";
  bool showSlide = true;

  @override
  void initState() {
    super.initState();

    count = sliderValue1.toInt();
    durationMilliseconds = sliderValue2.toInt();
  }

  String getRandomNum() {
    var keyNameTemp =
        _profileModel.jsonData![random.nextInt(_profileModel.jsonData!.length)];
    if (keyName == keyNameTemp) {
      return getRandomNum();
    } else {
      return keyNameTemp;
    }
  }

  void startLoading() {
    setState(() {
      showSlide = false;
    });
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
          keyName = getRandomNum();
        } else {
          if (_profileModel.selectedItem?.isNotEmpty ?? false) {
            if (_profileModel.jsonData!.contains(_profileModel.selectedItem)) {
              keyName = _profileModel.selectedItem!;
            } else {
              keyName = getRandomNum();
            }
          } else {
            keyName = getRandomNum();
          }
          timer.cancel();
          _timer = null;
          count = sliderValue1.toInt();
        }
      });
    });
  }

  // 数字文本随机颜色
  Color get _numColor {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    return Color.fromARGB(255, red, green, blue);
  }

  void _addNumber() {
    setState(() {
      keyName = getRandomNum();
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
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showSlide = !showSlide;
                    });
                  },
                  child: const Icon(Icons.swipe_left),
                ),
                SizedBox(
                  width: 20.0.h,
                ),
                FloatingActionButton(
                  onPressed: () {
                    startLoading();
                  },
                  child: const Icon(Icons.restart_alt_outlined),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Center(
                    child: SizedBox(
                      height: 0.3.sh,
                      width: 0.9.sw,
                      child: AnimatedSwitcher(
                        duration: Duration(
                            milliseconds: durationMilliseconds -
                                durationMilliseconds * 1 ~/ 10),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          Offset startOffset =
                              animation.status == AnimationStatus.completed
                                  ? const Offset(0.0, 1.0)
                                  : const Offset(0.0, -1.0);
                          Offset endOffset = const Offset(0.0, 0.0);
                          return SlideTransition(
                            position: Tween(begin: startOffset, end: endOffset)
                                .animate(
                              CurvedAnimation(
                                  parent: animation, curve: Curves.linear),
                            ),
                            child: FadeTransition(
                              opacity: Tween(begin: 0.1, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animation, curve: Curves.linear),
                              ),
                              child: ScaleTransition(
                                scale: Tween(begin: 0.3, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animation, curve: Curves.linear),
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          keyName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          key: ValueKey<String>(keyName),
                          style:
                              TextStyle(fontSize: textSize, color: _numColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _addNumber,
                    child: Text(
                      '单次随机',
                      style: TextStyle(
                          fontSize: 25,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                  SizedBox(
                    height: 150.0.h,
                  ),
                  showSlide
                      ? Column(
                          children: [
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
                              height: 25.0.h,
                            ),
                            Slider(
                              max: 200,
                              divisions: 10,
                              value: sliderValue3,
                              label: sliderValue3.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  if (value == 0.0) {
                                    return;
                                  }
                                  sliderValue3 = value;
                                  textSize = sliderValue3;
                                });
                              },
                            ),
                            Text("字体大小：${sliderValue3.toInt()}"),
                            SizedBox(
                              height: 50.0.h,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 0.0.h,
                        )
                ],
              ),
            )));
  }
}
