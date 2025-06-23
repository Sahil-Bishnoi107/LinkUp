import 'package:flutter/material.dart';

class logoprovider extends ChangeNotifier{
  bool waiting = true;
  void showlogo(){
    waiting = false;
   
    notifyListeners();
  }
}