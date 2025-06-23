import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkup/Firebase/Signin.dart';
import 'package:linkup/Providers/animationsprovider.dart';
import 'package:linkup/Widgets/LoginOptions.dart';
import 'package:linkup/screens/signup.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage>{
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: 
          Image.asset(
            "assets/bgimages/loginpage.png",
            fit: BoxFit.cover,
          )),

          //Content
        Container(
          height: height,width: width,
          margin: EdgeInsets.only(left: width*0.05),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ENTERIES
              Container(height: height*0.3,
              margin: EdgeInsets.only(left: width*0.17),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: height*0.07 ,),
                    Container(
                      child: Stack(
                      children: [
                         SvgPicture.asset("assets/images/logo.svg",height: height*0.12,width: width*0.12,),
                         Positioned(
                          top: height*0.085,left: width*0.06,
                          child: 
                         Container(
                        margin: EdgeInsets.only(right: width*0.2),
                        child:  Text("Bringing People Closer",
                        style: TextStyle(color: Color.fromRGBO(153, 0, 255, 1), fontFamily: MyTheme().loginfont),
                        )))
                ],
                )
                ),


                 
                 
                 ])
              ),
              ),
              LoginOption("EMAIL", height, width,Icons.account_circle,emailcontroller),
              SizedBox(height: height*0.01,),
              LoginOption("PASSWORD", height, width,Icons.security_rounded,passwordcontroller),
              SizedBox(height: height*0.04,),

              //FORGOT PASSWORD
              

              //LOGINBUTTON
              InkWell(
                onTap: () {
                  signin(context,emailcontroller.text , passwordcontroller.text);
                  context.read<ButtonAnimation>().clicked();
                },
                
             child: Material(
                elevation: context.watch<ButtonAnimation>().elevation,
                child: Container(
                  height: height*0.06,
                  width: width*0.9,
                  color: context.watch<ButtonAnimation>().buttoncolor,
                  child: Center(
                      child: Text("LOGIN",
                      style: TextStyle(color: context.watch<ButtonAnimation>().textcolor,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                  ),
                ),
              )),
              SizedBox(height: height*0.09,width: width*0.9,
              child: Center(
                child: Text("OR",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont),),
              ),
              ),

              // SIGNUUP
              InkWell(
                onTap: () {
                  GoogleSignin(context);
                },
             child: SignupButtons(height, width, "assets/images/googlelogo.svg",false,"CONTINUE WITH GOOGLE")),
              SizedBox(height: height*0.02,),
              InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
              },
             child:  SignupButtons(height, width, "assets/images/createaccountlogo.svg",true,"CREATE A NEW ACCOUNT"))
            ],
          ),
        )
        ],
      ),
    );
  }
}