import 'package:flutter/material.dart';
import 'package:iu_auditor/components/app_text.dart';

class AppTextButton extends StatelessWidget {
  final Function()? onPressed;
  final String btnText;
  final double? txtSize;
  const AppTextButton({super.key, this.onPressed, required this.btnText, this.txtSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AppTextRegular(text: btnText, color: Theme.of(context).primaryColor, fontSize: txtSize,),
    );
  }
}