import 'package:flutter/material.dart';

class TableColumnModel {
  final String title;
  final double? width;
  final Widget Function(dynamic rowData)? cellBuilder;

  TableColumnModel({
    required this.title,
    this.width,
    this.cellBuilder,
  });
}
