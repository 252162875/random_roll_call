import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../global.dart';
import '../profile_model.dart';
import '../route/router.dart';

ProfileModel get _profileModel => Global.profile;

class InitDataPage extends StatefulWidget {
  const InitDataPage({super.key});

  @override
  State<InitDataPage> createState() => _InitDataPageState();
}

class _InitDataPageState extends State<InitDataPage> {
  final TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  late String t;

  @override
  void initState() {
    super.initState();
    t = "";
    List l = _profileModel.jsonData ?? [];
    for (int i = 0; i < l.length; i++) {
      t += l[i];
      if (i < (l.length-1)) {
        t += "，";
      }
    }
    controller.text = t;
  }

  @override
  Widget build(BuildContext context) {
    String name = _profileModel.appName ?? "APP Name";
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 15.0.h),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(fontSize: 20.0.w),
                    controller: controller,
                    minLines: 5,
                    maxLines: 2000,
                    focusNode: focusNode,
                    onTapOutside: (e) => {focusNode.unfocus()},
                    decoration: InputDecoration(
                      labelText: "请输入或粘贴数据（以英文逗号“,”分隔）",
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 0.0),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            controller.clear();
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.w),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.0.h,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 20.0.h),
                child: MaterialButton(
                  minWidth: 0.8.sw,
                  padding: EdgeInsets.symmetric(vertical: 10.w),
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.w)),
                  onPressed: () {
                    try {
                      // List list = json.decode(controller.text.trim());
                      List<String> list = controller.text.trim().split("，");
                      logger.e(list.toString());
                      bool hasEmpty = false;
                      for (var a in list) {
                        if (a.isEmpty) {
                          hasEmpty = true;
                          break;
                        }
                      }
                      if (hasEmpty) {
                        Fluttertoast.showToast(msg: '数据格式错误，正确格式: A,B,C,D');
                      } else {
                        _profileModel.jsonData = list;
                        Global.saveProfile();
                        context.goNamed(home);
                      }
                    } catch (e, s) {
                      Fluttertoast.showToast(
                          msg: '数据格式错误，正确格式: A,B,C,D',
                          toastLength: Toast.LENGTH_LONG);
                    }
                  },
                  child: Text(
                    "保存",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.surface),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
