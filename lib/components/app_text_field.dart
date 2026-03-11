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
    this.fontFamily = FontFamily.inter,
    this.keyboardType = TextInputType.text,
    this.submitLabel = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.isTextFieldEnabled = true,
    this.placeholderColor = hintTextColor,
    this.focusedBorder,
    this.enabledBorder,
    this.obscureText = false,
    this.textFieldPadding = 0,
    this.minLine,
    this.maxLine,
    this.onTap,
    this.isError = false,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Error border — always used when isError is true
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.2),
    );

    // Default normal border — used as fallback when caller passes nothing
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    // FIX: caller-supplied borders are now actually used.
    // When isError is true, the error border always wins regardless.
    final resolvedFocusedBorder = isError
        ? errorBorder
        : (focusedBorder ?? defaultBorder);
    final resolvedEnabledBorder = isError
        ? errorBorder
        : (enabledBorder ?? defaultBorder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContainer(
          bgColor: isError
              ? Colors.red.withValues(alpha: 0.06)
              : backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
              // FIX: was fontFamily.toString() which produced "FontFamily.inter"
              // instead of "inter", causing the font to silently not load.
              fontFamily: fontFamily?.name,
              fontWeight: FontWeight.w400,
              color: primaryColor,
            ),
            cursorColor: placeholderColor,
            onChanged: onChanged,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              border: resolvedEnabledBorder,
              focusedBorder: resolvedFocusedBorder,
              enabledBorder: resolvedEnabledBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              hintText: placeholder,
              hintStyle: TextStyle(color: placeholderColor),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              // Hides the default Flutter error text — we render our own below
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
            validator: validator ?? (_) => null,
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
