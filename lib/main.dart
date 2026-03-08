import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/theme.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IU Auditor',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme(),
      home: const Login(),
    );
  }
}
