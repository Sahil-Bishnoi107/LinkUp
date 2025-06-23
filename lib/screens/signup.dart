import 'package:flutter/material.dart';
import 'package:linkup/Firebase/Signin.dart';
import 'package:linkup/Providers/animationsprovider.dart';
import 'package:linkup/Widgets/LoginOptions.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController rnamecontroller = new TextEditingController();
  TextEditingController ridcontroller = new TextEditingController();
  TextEditingController remailcontroller = new TextEditingController();
  TextEditingController rpasswordcontroller = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    return Scaffold(
      
      body: SingleChildScrollView(
      child: Stack(
        children: [
          Positioned.fill(child: 
          Image.asset("assets/bgimages/bgr.png",
          fit: BoxFit.fitHeight,
          )),

          //
          Container(
           height: height,width: width,
           margin: EdgeInsets.only(left: width*0.05),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height*0.07,),
              SizedBox(height: height*0.23, width: width*0.9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                 child:  Icon(Icons.arrow_back,color: MyTheme().logincolor,size: 40,)),


                  SizedBox(width: width*0.03,),
                  Container( margin: EdgeInsets.only(top: 4),
                 child:  Text("CREATE LINKUP ACCOUNT",style: TextStyle(
                    color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontSize: 20,fontWeight: FontWeight.bold
                  ),))
                ],
              ),
              ),
              LoginOption("NAME", height, width, Icons.person,rnamecontroller),
              SizedBox(height: height*0.02,),
              LoginOption("USERID", height, width, Icons.insert_drive_file_sharp,ridcontroller),
              SizedBox(height: height*0.02,),
              LoginOption("EMAIL", height, width, Icons.email,remailcontroller),
              SizedBox(height: height*0.02,),
              LoginOption("PASSWORD", height, width, Icons.security_rounded,rpasswordcontroller),
              SizedBox(height: height*0.05,),
              InkWell(
              onTap: () {
                context.read<ButtonAnimation>().clicked();
                Register(rnamecontroller.text, ridcontroller.text, remailcontroller.text, rpasswordcontroller.text, context);
              },
              child:Material(
                elevation: context.watch<ButtonAnimation>().elevation,
                child: Container(
                  height: height*0.06,
                  width: width*0.9,
                  color: context.watch<ButtonAnimation>().buttoncolor,
                  child: Center(
                      child: Text("REGISTER",
                      style: TextStyle(color: context.watch<ButtonAnimation>().textcolor,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                  ),
                ),
              )),
            ],
           ),
          )
        ],
      ),
    ));
  }
}