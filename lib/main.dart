import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/theme.dart';
import 'package:iu_auditor/core/service_locator.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IU Auditor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const Login(),
    );
  }
}