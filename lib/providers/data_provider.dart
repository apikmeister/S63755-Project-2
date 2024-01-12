import 'package:flutter/material.dart';

class DataNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
