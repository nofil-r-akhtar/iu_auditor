import 'package:flutter/material.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class AppOtpField extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  const AppOtpField({super.key, this.length = 4,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.onChanged,
    this.onSubmit,});

  @override
  Widget build(BuildContext context) {
    return PinInputTextFormField(
      controller: controller,
      focusNode: focusNode,
      pinLength: length,
      autoFocus: autoFocus,
      keyboardType: TextInputType.number,
      decoration: BoxLooseDecoration(
        strokeColorBuilder: PinListenColorBuilder(
          Colors.transparent,
          Colors.transparent // Default box (no border)
        ),
        radius: const Radius.circular(14),
        textStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: FontFamily.inter.name,
          fontSize: 20
        ),
        strokeWidth: 0, // No visible border
        gapSpace: 30, // Space between boxes
        bgColorBuilder: FixedColorBuilder(
          Theme.of(context).scaffoldBackgroundColor, // Soft grey background
        ),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      onSubmit: (value) {
        if (onSubmit != null) {
          onSubmit!(value);
        }
      },
    );
  }
}