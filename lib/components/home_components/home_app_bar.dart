import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';

AppBar appBar(BuildContext context,
    {
    required final String title,
    }) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsetsGeometry.only(left: 10),
      child: AppTextBold(
        text: title,
        color: navyBlueColor,
        fontFamily: FontFamily.inter,
        fontSize: 19),
    ),
    centerTitle: false,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: Row(
          children: [
            AppSvg(
              assetPath: bell
            ),
            SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextMedium(text: "Name", color: navyBlueColor),
                SizedBox(height: 5),
                AppTextRegular(text: "Role", color: descriptiveColor),
              ],
            ),
            SizedBox(width: 20),
            AppContainer(
              bgColor: navyBlueColor,
              shape: BoxShape.circle,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: AppTextRegular(text: "N", color: whiteColor,),
              ),
            )
          ],
        ),
      )
    ],
    backgroundColor: whiteColor,
    automaticallyImplyLeading: false,
  );
}