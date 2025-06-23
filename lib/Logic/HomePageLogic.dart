import 'package:flutter/material.dart';
import 'package:linkup/HomePagescreens.dart';
import 'package:linkup/Providers/BottomBarProvider.dart';
import 'package:provider/provider.dart';

Widget CurrentScreen(BuildContext context){
  int myindex = context.read<BarProvider>().selected;
  if(myindex == 1){
    return PROFILE();
  }
  if(myindex == 2){
    return Feed();
  }
  if(myindex == 3){
    return Friends();
  }
  else{
    return Home();
  }
}