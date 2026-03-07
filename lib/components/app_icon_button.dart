import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double? size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? padding;
  final double? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 8),
        child: Icon(
          icon,
          size: size ?? 24,
          color: iconColor ?? iconColor,
        ),
      ),
    );
  }
}