import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';

class AppTheme {
  static ThemeData lightTheme () {
    return ThemeData(
      scaffoldBackgroundColor: bgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        
      ),
      primaryColor: primaryColor,
      iconTheme: IconThemeData(
        color: iconColor,
      ),
    );
  }
}