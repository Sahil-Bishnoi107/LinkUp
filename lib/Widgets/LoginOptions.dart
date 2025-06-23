import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkup/theme/theme.dart';

Widget LoginOption(String mydes,double height,double width,IconData icon, TextEditingController mycontroller){
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mydes,
          style: TextStyle(fontSize: 15,color: Colors.white, fontFamily: MyTheme().loginfont),
        ),
        Material(
        elevation: 10,
       child:  Container(
        color: Colors.white,
          width: width*0.9,height: height*0.06,
           
            child: Row(
            children: [
             Container(
              width: width*0.1,
              child: Icon(icon,size: 30,color: MyTheme().logincolor,),),

             Container(
              width: 1,height: height*0.04,
              color: MyTheme().logincolor,
             ),
             SizedBox(width: 5,),
             Container(
              width: width * 0.7,
           child: TextField(
            controller: mycontroller,
            showCursor: false,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: MyTheme().loginfont,
                
                fontSize: 20,
                color: MyTheme().logincolor
              ),
          ),)
          ]
          ))
        )
      ],
    ),
  );
}


Widget SignupButtons(double height,double width,String icon,bool colored,String mytext){
  Widget myicon = colored ?
   SvgPicture.asset(icon,height: 30,width: 30,  color: MyTheme().logincolor,): SvgPicture.asset(icon,height: 30,width: 30,);
  return Container(
      child: Material(
        elevation: 10,
       child:  Container(
        color: Colors.white,
          width: width*0.9,height: height*0.06,  
            child: Row(
            children: [
              SizedBox(width: width*0.02,),
             Container(
              width: width*0.1,
              child: myicon),

             SizedBox(width: width*0.07,),
             Container(
              width: width * 0.7,
           child: Text(
              mytext,
              style: TextStyle(
                fontSize: 16,
                color: MyTheme().logincolor,
                fontFamily: MyTheme().loginfont
               // fontWeight: FontWeight.bold
              ),
          ),)
          ]
          ))
        )
  );
}