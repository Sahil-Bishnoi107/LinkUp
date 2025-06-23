import 'package:flutter/material.dart';
import 'package:linkup/theme/theme.dart';

class ButtonAnimation extends ChangeNotifier{
  double elevation = 10;
  Color buttoncolor = Colors.white;
  Color textcolor = MyTheme().logincolor;
  void clicked(){
    elevation = 0;
    buttoncolor = MyTheme().logincolor.withOpacity(0.6);
    textcolor = Colors.white;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), (){
    elevation = 10;
    buttoncolor = Colors.white;
    textcolor = MyTheme().logincolor;
    notifyListeners();
    });
  }
  
}