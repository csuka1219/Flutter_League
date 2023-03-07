import 'package:flutter/material.dart';

class DropDownProvider with ChangeNotifier {
  bool _dropdownOpen = false;
  bool get dropdownOpen => _dropdownOpen;
  void onButtonPressed() {
    _dropdownOpen = !_dropdownOpen;
    notifyListeners();
  }

  void setFalse() {
    _dropdownOpen = false;
    notifyListeners();
  }
}
