

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Providers/BottomBarProvider.dart';
import 'package:linkup/Providers/Homepageprovider.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

Widget clickIcon(IconData myicon,Color mycolor,double height,double width) {
   return Container(
    width: 50,height: 50,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(width: 2,color: mycolor),
    color: Colors.white,
    ),
    child: Icon(myicon,size: 35, color: mycolor),
   );
}

Widget HeadingText(double mysize,double height,double width,Color mycolor){
  return Container(
    height: height*0.08,width: width*0.4,
    padding: EdgeInsets.only(left: 1),
   child:  Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Link Up",
      style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().LogoFont,fontSize: 35,fontWeight: FontWeight.bold,),
    ),)
  );
}

Widget HeaderOptions (double width,double height){
  return Consumer<HeaderOptionProvider>(
    builder: (context,provider,child){
      int selected = provider.selected;
      return Container(
        width: width*0.9, height: height*0.05,
        child: Row(
          children: [
            //OPTION1
             option(selected, 1, width, "CHATS", context,height,),
             option(selected, 2, width, "TEAMS", context,height,),
             option(selected, 3, width, "GROUPS", context,height,)
          ],
        ),
      );
    }
    );
}

Widget option(int selected,int index,double width,String mytext,BuildContext context,double height){
double myelevation = selected == index ? 3 : 0;
Color mycolor = selected == index ? MyTheme().logincolor : Colors.white;
Color textcolor = selected != index ? MyTheme().logincolor : Colors.white;
 return InkWell(
              onTap: () {
                context.read<HeaderOptionProvider>().changeSelected(index);  
              },
              child: Material(
                elevation: myelevation,
                child: Container(
                  width: width*0.3, height: height*0.05,
                  color: mycolor,
                  child:Center(
                  child: Text(mytext,style: TextStyle(color: textcolor,fontSize: 20,
                  fontFamily: MyTheme().bottomFont, fontWeight: FontWeight.bold
                  ),)),
                ),
              ),
             );
}



BottomNavigationBar mybar(BuildContext context){
  return BottomNavigationBar(
    onTap: (Index) {
      context.read<BarProvider>().ChangeSelected(Index);
    },
        currentIndex: context.watch<BarProvider>().selected,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(
         fontFamily: MyTheme().bottomFont,
         fontSize: 10
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: MyTheme().bottomFont,
         fontSize: 10,
         fontWeight: FontWeight.bold
        ),
        selectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.black
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
          size: 30
        ),
        items: [
        BottomNavigationBarItem(icon:context.watch<BarProvider>().selected == 0 ? Icon(Icons.home) : Icon(Icons.home_outlined),label: ""),
        BottomNavigationBarItem(icon:context.watch<BarProvider>().selected == 1 ?  Icon(Icons.person_2_rounded) : Icon(Icons.person_2_outlined),label: "" ),
        BottomNavigationBarItem(icon:context.watch<BarProvider>().selected == 2 ? Icon(Icons.feed,size: 26,) :Icon(Icons.feed_outlined,size: 26,),label: ""),
        BottomNavigationBarItem(icon:context.watch<BarProvider>().selected == 3 ? Icon(Icons.people) : Icon(Icons.people_outline),label: "")
      ]);
}


