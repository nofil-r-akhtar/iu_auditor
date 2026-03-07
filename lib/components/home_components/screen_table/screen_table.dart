import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor/modal_class/table/table_model.dart';

class ScreenTable extends StatelessWidget {
  final List<TableColumnModel> columns;
  final List<dynamic>? data; // nullable
  final ScreenTableController controller;

  const ScreenTable({
    super.key,
    required this.columns,
    this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
  // access observable directly
  // final currentPage = controller.currentPage.value;

  final start = data != null ? controller.getStartIndex() : 0;
  final end = data != null ? controller.getEndIndex(data!.length) : 0;
  final currentData =
      data != null ? data!.sublist(start, end) : <dynamic>[];

  return Column(
    children: [
      Header(columns: columns),
      const Divider(height: 1),
      if (currentData.isNotEmpty)
        ...currentData.map(
          (row) => BuildRow(
            columns: columns,
            rowData: row,
          ),
        )
      else
        AppContainer(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "No data available",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      if (data != null && data!.isNotEmpty)
        Pagination(
          controller: controller,
          dataLength: data!.length,
        ),
    ],
  );
});
  }
}

class Pagination extends StatelessWidget {
  final ScreenTableController controller;
  final int dataLength;
  const Pagination({
    required this.controller,
    required this.dataLength,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: controller.previousPage,
          icon: const Icon(Icons.chevron_left),
        ),
        Obx(() {
          final totalPages =
              (dataLength / controller.rowsPerPage).ceil();
          return Text(
              "${controller.currentPage.value + 1} / $totalPages");
        }),
        IconButton(
          onPressed: () =>
              controller.nextPage(dataLength),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final List<TableColumnModel> columns;

  const Header({
    super.key,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: 14),
      bgColor: bgColor,
      child: Row(
        children: columns.map((column) {
          return Expanded(
            child: AppTextSemiBold(
              text: column.title,
              color: navyBlueColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BuildRow extends StatelessWidget {
  final List<TableColumnModel> columns;
  final dynamic rowData;

  const BuildRow({
    super.key,
    required this.columns,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile: stacked view
      return AppContainer(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns.map((column) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${column.title}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: navyBlueColor,
                    ),
                  ),
                  Expanded(
                    child: column.cellBuilder != null
                        ? column.cellBuilder!(rowData)
                        : Text(
                            rowData[column.title]?.toString() ?? "",
                            style: TextStyle(color: descriptiveColor),
                          ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    } else {
      // Desktop / Tablet: row view
      return AppContainer(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: columns.map((column) {
            return Expanded(
              child: column.cellBuilder != null
                  ? column.cellBuilder!(rowData)
                  : AppTextMedium(
                      text: rowData[column.title]?.toString() ?? "",
                      color: descriptiveColor,
                    ),
            );
          }).toList(),
        ),
      );
    }
  }
}