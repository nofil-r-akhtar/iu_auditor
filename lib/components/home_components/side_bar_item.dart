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
    super.key,
  });

  Color _getColor() {
    if (name.isEmpty) return icColor ?? iconColor;
    if (name == "Sign Out") return redColor;
    if (isSelected) return whiteColor;
    return iconColor;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Row(
      children: [
        AppSvg(assetPath: icon, color: color, height: 25, width: 25),
        SizedBox(width: 10),
        AppTextMedium(text: name, color: color, fontSize: 20),
      ],
    );
  }
}
