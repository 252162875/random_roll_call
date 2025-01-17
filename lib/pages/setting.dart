import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../profile_change_notifier.dart';
import '../profile_model.dart';
import '../route/router.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ProfileModel get _profileModel => Global.profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void showAlertDialog(Function(String text) onConfirm) {
    final TextEditingController controller = TextEditingController();
    FocusNode focusNode = FocusNode();
    var dialog = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                onSubmitted: (text) {
                  onConfirm(controller.text);
                  Navigator.pop(context);
                },
                textInputAction: TextInputAction.done,
                controller: controller,
                focusNode: focusNode,
                maxLines: 1,
                onTapOutside: (e) => {focusNode.unfocus()},
                decoration: InputDecoration(
                  labelText: "请输入",
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.w),
                  ),
                )),
            SizedBox(
              height: 15.0.h,
            ),
            MaterialButton(
              onPressed: () {
                onConfirm(controller.text);
                Navigator.pop(context);
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text("确定"),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      "主题",
      "修改主页名称",
      "自定义选择",
      "数据管理",
    ];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("设置"),
        ),
        body: ListView.separated(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Consumer<ThemeChangeNotifier>(
                builder: (context, themeChangeNotifier, child) {
              return _ListItemView(
                handleTap: () {
                  switch (index) {
                    case 0:
                      List<PopupMenuEntry<MaterialColor>> themeMenuItems = [];
                      for (var e in Global.themes) {
                        var popMenuItem = PopupMenuItem(
                            value: e,
                            onTap: () {
                              themeChangeNotifier.theme = e;
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              alignment: Alignment.centerRight,
                              width: double.infinity,
                              height: kMinInteractiveDimension,
                              color: e,
                              child: themeChangeNotifier.theme == e
                                  ? Icon(Icons.done,
                                      color: Theme.of(context).indicatorColor)
                                  : null,
                            ));
                        themeMenuItems.add(popMenuItem);
                      }
                      showMenu<MaterialColor>(
                          constraints: BoxConstraints.tightForFinite(
                              width: 0.7.sw, height: 0.5.sh),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            0.5.sw,
                            ScreenUtil().statusBarHeight +
                                AppBar().preferredSize.height,
                            0,
                            0,
                          ),
                          initialValue: themeChangeNotifier.theme,
                          items: themeMenuItems);
                      break;
                    case 1:
                      showAlertDialog((text) {
                        _profileModel.appName = text;
                        Global.saveProfile();
                        Fluttertoast.showToast(msg: "设置成功");
                      });
                      break;
                    case 2:
                      List<String> itemData = ["*#*#无*#*#"];
                      itemData.addAll(_profileModel.jsonData ?? []);
                      List<PopupMenuEntry<String>> selectedItemMenus = [];
                      for (var e in itemData) {
                        var popMenuItem = PopupMenuItem<String>(
                            value: ("*#*#无*#*#" == e) ? "无" : e,
                            onTap: () {
                              if (e == "*#*#无*#*#") {
                                _profileModel.selectedItem = null;
                              } else {
                                _profileModel.selectedItem = e;
                              }
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              height: kMinInteractiveDimension,
                              color: ("*#*#无*#*#" == e &&
                                      _profileModel.selectedItem == null)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : (_profileModel.selectedItem == e
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null),
                              child: Text(
                                ("*#*#无*#*#" == e) ? "无" : e,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ));
                        selectedItemMenus.add(popMenuItem);
                      }
                      showMenu<String>(
                          constraints: BoxConstraints.tightForFinite(
                              width: 0.7.sw, height: 0.5.sh),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            0.5.sw,
                            ScreenUtil().statusBarHeight +
                                AppBar().preferredSize.height,
                            0,
                            0,
                          ),
                          initialValue: _profileModel.selectedItem,
                          items: selectedItemMenus);
                      break;

                    case 3:
                      context.goNamed(manageData);
                      break;
                    default:
                      Fluttertoast.showToast(msg: "=====Empty=====");
                  }
                },
                textData: items[index] ?? "Empty",
              );
            });
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 1.0,
              height: 1.0,
              indent: 15.0,
              endIndent: 15.0,
              color: Theme.of(context).dividerColor,
            );
          },
        ));
  }
}

class _ListItemView extends StatelessWidget {
  const _ListItemView({
    required this.handleTap,
    required this.textData,
  });

  final void Function() handleTap;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleTap();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(textData), const Icon(Icons.arrow_forward_ios)],
          ),
        ),
      ),
    );
  }
}
