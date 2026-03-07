import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';

class SideBarItem extends StatelessWidget {
  final String icon;
  final String name;
  final Color? icColor;
  final bool isSelected;
  const SideBarItem({
    required this.icon,
    required this.name,
    this.isSelected = false,
    this.icColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(assetPath: icon, 
        color: name.isEmpty ? icColor : name  == "Sign Out" ? redColor : isSelected ? whiteColor : iconColor, height: 25, width: 25,
        ),
        SizedBox(width: 10),
        AppTextMedium(text: name, color: name == "Sign Out" ? redColor : isSelected ? whiteColor : iconColor, fontSize: 20,)
      ],
    );
  }
}