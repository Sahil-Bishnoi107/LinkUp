import 'package:flutter/material.dart';

class HeaderOptionProvider extends ChangeNotifier{
  int selected = 1;
  void changeSelected(int select){
    selected = select;
    notifyListeners();
  }
}

class FriendsHeaderOptionProvider extends ChangeNotifier{
  int selection = 1;
  void changeSelected(int select){
    selection = select;
    notifyListeners();
  }
}