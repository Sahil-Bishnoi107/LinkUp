import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Logic/Cloudinary.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Providers/ProfileProvider.dart';
import 'package:linkup/Providers/ViewProfileProvider.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Viewprofile extends StatefulWidget {
  final String uid;
  const Viewprofile({super.key, required this.uid});

  @override
  State<Viewprofile> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Viewprofile> {
  TextEditingController biocontroller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
  
 
  @override
  void initState() {
    super.initState();
    context.read<ViewProfileProvider>().getProfileInfo(widget.uid);
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int length = context.read<ViewProfileProvider>().nooffriends;
    
   return Scaffold(
    backgroundColor: Colors.white,
      body:  Consumer<ViewProfileProvider>(
        builder: (context, provider, child) {
          citycontroller.text = provider.city;
          biocontroller.text = provider.bio;
        return
        provider.userid == ""?
        Center(child: Text(
        "Loading..." , style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().bottomFont),
        ),)
        
        :
        SingleChildScrollView( 
          child: Stack(
          children: [
           Container(height: height,width: width,
           child:  Image.asset(zz().bg,fit: BoxFit.cover,)
           ),
           Container(height: height*1.03,width: width,
           child: Column(
            children: [
              SizedBox(height: height*0.03,),
              backbutton(height, width,provider,context),
              profilehead(height, width,length,context,biocontroller,citycontroller,provider),
              
            ],
           ),
           )
          ],
              ),
        );}
      ));
  }
}


Widget backbutton(double height, double width,ViewProfileProvider provider,BuildContext context){
  return Container(
    height: height*0.05,width: width*0.9,
   // margin: EdgeInsets.only(left: 10),
    child: Align(alignment: Alignment.centerLeft,
      child: IconButton(onPressed: (){
        provider.cleardata();
        Navigator.pop(context);
      },
       icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
    ),
  );
}

Widget profilehead(double height,double width,int length,BuildContext context,TextEditingController biocontroller,TextEditingController citycontroller,ViewProfileProvider provider){
 return Container(
  height: height*0.95,width: width*0.9,
  
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
 
           Container(
            height: height*0.12,width: width*0.27,
            decoration: BoxDecoration(shape: BoxShape.circle,),
            child: provider.profilepic == "" ? SizedBox() : ClipOval(
              child: Image.network(
                provider.profilepic,
                fit: BoxFit.cover,
              ),
            ),
          ),
      SizedBox(height: 5,),
      Container(height: 30,
      child: 
         Text(provider.username, style: TextStyle(fontFamily: MyTheme().textFont4,color: zz().name,fontWeight: FontWeight.w500,fontSize: 25))),
      SizedBox(height: 1,),

      Container( height: 30,width: width*0.9,
      alignment: Alignment.bottomCenter,
      child:  
      
       Text(provider.userid,style: TextStyle(color:zz().id,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.w500,fontSize: 17),)),

      SizedBox(height: 10,),
      Container(
       // margin: EdgeInsets.only(right: width*0.1),
        width: width,
     child:  Row(
      mainAxisAlignment: MainAxisAlignment.start,
     // mainAxisSize: MainAxisSize.min,
        children: [
        SizedBox(width: width*0.19,),
        Icon(Icons.location_on,color: zz().location,size: 30,),
        SizedBox(width: width*0.03,),
        
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: width*0.6,height: height*0.04,
          alignment: Alignment.centerLeft,
          child:  
              TextField(
              decoration: InputDecoration(border: InputBorder.none),
              controller: citycontroller,
              enabled: false,
              style: TextStyle(color: zz().location,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.w500,fontSize: 20,),
             ), 
        ),
      ]),),
       SizedBox(height: 15,),
      
       
        ConstrainedBox(
          
          constraints: BoxConstraints(
           maxHeight: height * 0.19, 
           ),
           child: Material(elevation: 1,
           color: Colors.white,
           
             child: Column(
              mainAxisSize: MainAxisSize.min,
               children: [
                 Material(elevation: 0,
                 color: Colors.white, 
                 child: Container(
                  margin: EdgeInsets.only(left: 5,top: 5),
                  width: width*0.9,
                  child: Row(
                    children: [
                      Icon(Icons.edit,color: zz().icon,size: 20,),
                      SizedBox(width: 5,),
                      Text("About Me!",style: TextStyle(fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold,color: zz().des),),
                      SizedBox(width: width*0.175,),
                
                    ],
                  )),),
                  Container(height: 1,width: width*0.88,color: zz().icon,),
           
                 Flexible(
                   child: SingleChildScrollView(
                     child: Container(
                      padding: EdgeInsets.all(10),
                      width: width*0.9,color: Colors.white,
                      child:
                      
                       
                        
                        TextField(
                        controller: biocontroller,
                          maxLines: null, 
                          enabled: false,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 13,color: zz().biotext),
                        )
                       
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),

       // OUR INTRESTS
          SizedBox(height: 20,),
          interests(height,width,context,provider),

      //Data
      SizedBox(height: 20,),
      boxs(height, width, length.toString(), "0", "0"),
      SizedBox(height: height*0.1,),

    ],
  ),
 );
}


Widget interests(double height,double width,BuildContext context, ViewProfileProvider provider){
  
  TextEditingController intrestcontroller = new TextEditingController();
    return
     Material(
      color: Colors.white,
     elevation: 1,
     child: Column(
      mainAxisSize: MainAxisSize.min,
       children: [
        Container(width: width*0.9,height: height*0.03,color: Colors.white,
        margin: EdgeInsets.only(left: 10,top: 5),
        child: Row(
          children: [
            Icon(Icons.emoji_objects_sharp,color: zz().icon,size: 20,),
            SizedBox(width: 5,),
            Text("MY INTERESTS",style: TextStyle(color: zz().des,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),),
            SizedBox(width: width*0.47,),
          ],
        ),
        ),
         Container(width: width*0.88,height: 1,color: zz().icon),
         SizedBox(height: 5,),
    
         intrestsspace(height,width,context,provider),
         
       ],
     ),
    );
}


Widget intrestsspace(double height,double width,BuildContext context,ViewProfileProvider provider){
 return provider.intrests.length == 0 ? 
 Container(
        width: width*0.9,height: height*0.05,color: Colors.white,
        child: Center(
          child: Text("NO INTREST MENTIONED",style: TextStyle(fontFamily: MyTheme().loginfont,color: zz().intrest,fontWeight: FontWeight.bold),),
        ),
        )
 : Container(
        width: width*0.9,height: height*0.09,color: Colors.white,
        child: GridView.builder(
          padding: EdgeInsets.all(5),
          itemCount: provider.intrests.length,
          scrollDirection: Axis.vertical,
         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width*0.27,mainAxisSpacing: 10,crossAxisSpacing: 10,mainAxisExtent: height * 0.03),
         itemBuilder: (context,index){
          final intrest = provider.intrests[index];
          return Material(
            elevation: 0, color: Colors.white,
            child: Center(child: Text(intrest,style: TextStyle(color: zz().intrest,fontFamily: MyTheme().loginfont),)),
          );
         }
         ),
       );
}


Widget boxs(double height,double width,String data1,String data2,String data3){
  return Container(
    height: height*0.15, width: width*0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        box(height, width, "FRIENDS",data1 , zz().box),
        SizedBox(width: width*0.1,),
        box(height, width, "CUSTOM",data2 , zz().box),
        SizedBox(width: width*0.1,),
        box(height, width, "DOCUMENTS",data3 , zz().box),
      ],
    ),
  );
}

Widget box(double height,double width,String header,String data,Color mycolor){
  return Material(
    elevation: 5,
    child: Container(
      decoration: BoxDecoration(color: mycolor,borderRadius: BorderRadius.circular(2)),
      height: height*0.1,width: width*0.23, 
      child: Column(
        children: [
          SizedBox(height: height*0.005,),
          Text(header,style: TextStyle(color: zz().boxtext,fontFamily: MyTheme().loginfont,fontSize: 10),),
          SizedBox(height: height*0.002,),
          Container(width: width*0.18,height: 1,color: zz().boxtext,),
          SizedBox(height: height*0.012,),
          Text(data,style: TextStyle(color: zz().boxtext,fontFamily: MyTheme().loginfont,fontSize: 25),)
        ],
      ),
    ),
  );
}


