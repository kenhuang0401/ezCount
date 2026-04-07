import 'package:flutter/material.dart';

class PageIndex extends ChangeNotifier {
  int __currentPageIndex = 0;
  int get currentPageIndex => __currentPageIndex;

  void setIndex(int idx) {
    __currentPageIndex = idx;
    notifyListeners();
  }
}