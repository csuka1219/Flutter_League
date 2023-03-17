import 'package:flutter/material.dart';

class DropDownProvider with ChangeNotifier {
  bool _dropdownOpen = false;
  bool get dropdownOpen => _dropdownOpen;
  String _summomnerName = "";
  void onButtonPressed() {
    _dropdownOpen = !_dropdownOpen;
    notifyListeners();
  }

  void setFalse() {
    _dropdownOpen = false;
    notifyListeners();
  }

  String get summomnerName => _summomnerName;

  set summomnerName(String value) {
    _summomnerName = value;
    notifyListeners();
  }
}
