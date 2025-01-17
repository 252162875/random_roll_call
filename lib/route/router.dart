import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_roll_call/pages/initData.dart';
import 'package:random_roll_call/pages/setting.dart';
import 'package:route_life/route_life.dart';
import '../error.dart';
import '../pages/home.dart';
import '../pages/splash.dart';
import 'my_nav_observer.dart';

final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          name: splash,
          builder: (_, GoRouterState state) => const SplashPage(),
          routes: [
            GoRoute(
              path: 'initData',
              name: initData,
              builder: (_, GoRouterState state) => const InitDataPage(),
            ),
            GoRoute(
                path: 'home',
                name: home,
                builder: (_, GoRouterState state) => const HomePage(),
                routes: [
                  GoRoute(
                      path: 'setting',
                      name: setting,
                      builder: (_, GoRouterState state) => const SettingPage(),
                      routes: [
                        GoRoute(
                          path: 'manageData',
                          name: manageData,
                          builder: (_, GoRouterState state) =>
                              const InitDataPage(),
                        )
                      ]),
                ])
          ]),
    ],
    errorBuilder: (context, GoRouterState state) {
      return const ErrorPage();
    },
    debugLogDiagnostics: true,
    observers: [MyNavObserver(), RouteLifeObserver()]);

const String setting = 'setting';
const String initData = 'initData';
const String manageData = 'manageData';
const String splash = 'splash';
const String home = 'home';
const String scan = 'scan';
const String scanResult = 'scanResult';
const String scanHistory = 'scanHistory';
const String createHistory = 'createHistory';
const String createTypes = 'createTypes';
const String createCode = 'createCode';
