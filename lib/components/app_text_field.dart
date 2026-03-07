import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/const/enums.dart';

class AppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? placeholder;
  final Color? backgroundColor;
  final TextEditingController textController;
  final bool? isSecured;
  final double? fontSize;
  final FontFamily? fontFamily;
  final TextInputType? keyboardType;
  final TextInputAction? submitLabel;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? isTextFieldEnabled;
  final Color? placeholderColor;
  final InputBorder? outlineBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final bool obscureText;
  final double textFieldPadding;
  final int? minLine;
  final int? maxLine;
  final Function()? onTap;
  final bool isError;
  final String? errorText;
  const AppTextField({
  this.prefixIcon,
      this.suffixIcon,
      this.placeholder,
      this.backgroundColor = bgColor,
      required this.textController,
      this.isSecured = false,
      this.fontSize = 16.0,
      this.fontFamily =
          FontFamily.inter, // replace with your actual font family
      this.keyboardType = TextInputType.text,
      this.submitLabel = TextInputAction.next,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.isTextFieldEnabled = true,
      this.placeholderColor = primaryColor,
      this.outlineBorder = InputBorder.none, 
      // = const OutlineInputBorder(
      //   borderSide: BorderSide(
      //       color: primaryColor, width: 0.25, style: BorderStyle.none),
      // ),
      this.focusedBorder = InputBorder.none,
      // = const OutlineInputBorder(
      //   borderSide: BorderSide(color: primaryColor, width: 0.25),
      // ),
      this.enabledBorder = InputBorder.none,
      //  = const OutlineInputBorder(
      //   borderSide: BorderSide(
      //       color: primaryColor, width: 0.1, style: BorderStyle.none),
      // ),
      this.obscureText = false,
      this.textFieldPadding = 0,
      this.minLine,
      this.maxLine,
      this.onTap,
      this.isError = false,       // <-- new
      this.errorText,
      super.key});

  @override
  Widget build(BuildContext context) {
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    );
    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContainer(
          bgColor: isError
                  ? Colors.red.withValues(alpha: 0.06)   // subtle red tint on error
                  : backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 8),
          borderRadius: BorderRadius.circular(12),
          alignment: Alignment.topCenter,
          child: TextFormField(
            maxLines: (minLine ?? 1) > 1 ? null : 1,
            onTap: onTap,
            minLines: minLine,
            controller: textController,
            keyboardType: keyboardType,
            textInputAction: submitLabel,
            enabled: isTextFieldEnabled,
            obscureText: obscureText,
            style: TextStyle(
                fontSize: fontSize,
                height: 1.5,
                fontFamily: fontFamily.toString(),
                fontWeight: FontWeight.w400,
                color: primaryColor),
            cursorColor: placeholderColor,
            onChanged: onChanged,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
               border: isError ? errorBorder : normalBorder,
              focusedBorder: isError ? errorBorder : normalBorder,
              enabledBorder: isError ? errorBorder : normalBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              // labelText: placeholder,
              // labelStyle: TextStyle(fontSize: 14, color: placeholderColor, fontWeight: FontWeight.w400, fontFamily: fontFamily.toString()),
              // hintStyle: TextStyle(color: placeholderColor),
              hintText: placeholder,
              hintStyle: TextStyle(color: placeholderColor),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
            validator: validator ?? (_) => 'TextField is not Empty',
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        if (isError && errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    ); 
  }
}