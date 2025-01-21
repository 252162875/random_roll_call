import 'package:flutter/material.dart';
import 'package:random_roll_call/pages/home.dart';
import 'home_new.dart';
import '../global.dart';
import '../profile_model.dart';
import 'initData.dart';

class SplashPage extends StatefulWidget {
  final String? typeName;

  const SplashPage({super.key, this.typeName});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ProfileModel get _profileModel => Global.profile;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_profileModel.jsonData?.isNotEmpty ?? false)
          ? const HomeNewPage()
          : const InitDataPage(),
    );
  }
}
