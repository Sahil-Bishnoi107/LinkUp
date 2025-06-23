import 'package:flutter/material.dart';

class BarProvider extends ChangeNotifier{
  int selected = 0;
  void ChangeSelected(int changedselected){
    selected = changedselected;
    notifyListeners();
  }
}