import 'package:flutter/material.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text_field.dart';

class ScreenSearchBar extends StatelessWidget {
  final TextEditingController searchFieldController;
  final String searchFieldDummyText;

  const ScreenSearchBar({
    required this.searchFieldController,
    required this.searchFieldDummyText,

    super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    return AppContainer(
      bgColor: whiteColor,

      borderRadius: BorderRadius.circular(16),
      padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
      child: Row(
        children: [
          SizedBox(
            width: isDesktop
                    ? 500 : isTablet ? 350 : 300,
            child: AppTextField(
              textController: searchFieldController,
              placeholder: searchFieldDummyText,
              placeholderColor: iconColor,
              prefixIcon: Icon(
                Icons.search
              ),
              backgroundColor: whiteColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: iconColor,
                  width: 0.5
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}