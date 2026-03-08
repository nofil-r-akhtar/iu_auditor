import 'package:flutter/material.dart';
import 'package:iu_auditor/const/enums.dart';

class AppTextThin extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  const AppTextThin({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //// maxLines: lineLimit!,
      textAlign: textAlign,
      softWrap: true,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w200,
        fontFamily: fontFamily?.name,
        color: color,
      ),
    );
  }
}

class AppTextRegular extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  const AppTextRegular({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //maxLines: lineLimit!,
      // overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      // softWrap: true,
      style: TextStyle(
        // overflow: TextOverflow.ellipsis,
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w300,
        fontFamily: fontFamily?.name,
        color: color,
      ),
    );
  }
}

class AppTextMedium extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  const AppTextMedium({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      ////// maxLines: lineLimit!,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily?.name,
        color: color,
      ),
    );
  }
}

class AppTextSemiBold extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  final double? h;
  const AppTextSemiBold({
    super.key,
    required this.text,
    this.h,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // maxLines: lineLimit!,
      textAlign: textAlign,
      style: TextStyle(
        height: h,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily?.name,

        color: color,
      ),
    );
  }
}

class AppTextBold extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  final TextDecoration? textDecoration;

  const AppTextBold({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit = 4,
    this.color,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: lineLimit!,
      style: TextStyle(
        height: 1,
        decoration: textDecoration,
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.w800,
        fontFamily: fontFamily?.name,
        color: color,
      ),
    );
  }
}

class AppTextItalic extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontFamily? fontFamily;
  final TextAlign? textAlign;
  final Color? color;
  final int? lineLimit;
  const AppTextItalic({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.color,
    this.lineLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      ////// maxLines: lineLimit!,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize ?? 18,
        fontStyle: FontStyle.italic,
        fontFamily: "raleway",
        color: color,
      ),
    );
  }
}

class AppTextHeavyBold extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontFamily? fontFamily;
  final Color? color;
  final int? lineLimit;
  const AppTextHeavyBold({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.fontFamily,
    this.lineLimit = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // maxLines: lineLimit!,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily?.name,
        color: color,
      ),
    );
  }
}
