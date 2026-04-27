import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/theme.dart';
import 'package:iu_auditor/core/service_locator.dart';
import 'package:iu_auditor/screens/splash/splash_screen.dart';
import 'package:iu_auditor/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPreferences before runApp so token is ready by splash
  await StorageService().init();
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
      home: const SplashScreen(),  // ← was Login()
    );
  }
}