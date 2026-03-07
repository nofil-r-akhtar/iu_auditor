import 'package:get/get.dart';

class ScreenTableController extends GetxController{
  final int rowsPerPage;

  ScreenTableController({this.rowsPerPage = 10});

  RxInt currentPage = 0.obs;

  int getStartIndex() => currentPage.value * rowsPerPage;

  int getEndIndex(int totalLength) {
    final end = getStartIndex() + rowsPerPage;
    return end > totalLength ? totalLength : end;
  }

  void nextPage(int totalLength) {
    final totalPages = (totalLength / rowsPerPage).ceil();
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void reset() {
    currentPage.value = 0;
  }
}