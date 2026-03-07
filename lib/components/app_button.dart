import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';

class AppButton extends StatelessWidget {
  final Color bgColor;
  final String txt;
  final Color? txtColor;
  final EdgeInsetsGeometry? padding;
  final Function()? onPress;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;

  // NEW
  final Widget? icon;
  final double spacing;

  const AppButton({
    this.bgColor = primaryColor,
    this.txtColor = whiteColor,
    this.txt = "Next",
    this.padding,
    this.onPress,
    this.borderRadius,
    this.border,
    this.alignment,
    this.boxShadow,
    this.icon,
    this.spacing = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: AppContainer(
        bgColor: bgColor,
        padding: padding,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        alignment: alignment ?? Alignment.center,
        border: border,
        boxShadow: boxShadow,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: spacing),
            ],
            AppTextRegular(
              text: txt,
              color: txtColor,
            ),
          ],
        ),
      ),
    );
  }
}