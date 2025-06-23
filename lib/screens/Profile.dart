import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkup/Logic/Cloudinary.dart';
import 'package:linkup/Posts/postspage.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Providers/ProfileProvider.dart';
import 'package:linkup/screens/ViewProfile.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  TextEditingController biocontroller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
 
  @override
  void initState() {
    super.initState();
    context.read<Profileprovider>().checkIntrests();
    context.read<Profileprovider>().checkBio();
    context.read<Profileprovider>().getProfileImage();
    context.read<Profileprovider>().getmyowninfo();
  }
  
  @override
  Widget build(BuildContext context) {
    
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int length = context.read<Friendsprovider>().friends.length;
    
   return Scaffold(
    backgroundColor: Colors.white,
      body:  Stack(
      children: [
       Container(height: height*0.99,width: width,
       //color: Color.fromRGBO(80, 50, 150, 1),
       child: Image.asset(zzz().bg,fit: BoxFit.cover,),
       ),
       SingleChildScrollView(
         child: Container(height: height*1.75,width: width,
         child: Column(
          children: [
            SizedBox(height: height*0.03,),
            backbutton(height, width),
            profilehead(height, width,length,context,biocontroller,citycontroller),
            
          ],
         ),
         ),
       )
      ],
          ));
  }
}


Widget backbutton(double height, double width){
  return Container(
    height: height*0.05,width: width*0.9,
    
  );
}

Widget profilehead(double height,double width,int length,BuildContext context,TextEditingController biocontroller,TextEditingController citycontroller){
 return Container(
  height: height*1.6,width: width*0.94,
  
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      InkWell(
        onLongPress: () {
          UploadImage(context);
          context.read<Profileprovider>().getProfileImage();
        },
        child: Selector<Profileprovider,String>(
          selector: (context, provider) => provider.url,
          builder: (context, value, child) => 
           Container(
            height: height*0.12,width: width*0.27,
            decoration: BoxDecoration(shape: BoxShape.circle,),
            child: value == "" ?  
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.white)),
              child: Center(child: Text("Upoad Image",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.white),),),
            )
            
            
            : ClipOval(
              child: Image.network(
                value,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 5,),
      Container(height: 30,
      child:  Selector<Profileprovider,String>(
        selector: (p0, p1) => p1.myname,
        builder: (context, value, child) => 
         Text(value, style: TextStyle(fontFamily: MyTheme().textFont4,color: zzz().name,fontWeight: FontWeight.w500,fontSize: 25))),),
      SizedBox(height: 1,),

      Container( height: 30,width: width*0.9,
      alignment: Alignment.bottomCenter,
      child:  Selector<Profileprovider,String>(
      selector: (p0, p1) => p1.myId,
      builder: (context, value, child) => Text(value,style: TextStyle(color: zzz().id,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.w500,fontSize: 17),))),

      SizedBox(height: 10,),
      Container(
       // margin: EdgeInsets.only(right: width*0.1),
        width: width,
     child:  Row(
      mainAxisAlignment: MainAxisAlignment.start,
     // mainAxisSize: MainAxisSize.min,
        children: [
        SizedBox(width: width*0.19,),
        Icon(Icons.location_on,color: zzz().locationicon,size: 30,),
        SizedBox(width: width*0.03,),
        
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: width*0.55,height: height*0.04,
          alignment: Alignment.centerLeft,
          child: Consumer<Profileprovider>(
            builder: (context,provider,child){
              String mycity = provider.city == ""? "Mars,Milky Way" : provider.city;
              citycontroller.text = mycity;  
             return TextField(
              decoration: InputDecoration(border: InputBorder.none),
              controller: citycontroller,
              enabled: provider.editcity,
              style: TextStyle(color: zzz().location,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.w500,fontSize: 20,),
             );
            },
           ),
        ),

        InkWell(
          onTap: () {
           bool x =  context.read<Profileprovider>().editcity;
           if(x){
            context.read<Profileprovider>().updatecity(citycontroller.text);
            context.read<Profileprovider>().togglecityedit();
           }
           else{context.read<Profileprovider>().togglecityedit();}
          },
          child: Icon(Icons.edit,color: zzz().edit1,),
        )
      ]),),
       SizedBox(height: 15,),
      
       
       Consumer<Profileprovider>(
        builder: (context, provider, child) {
          String mybio = provider.bio;
           bool edittext = provider.edittext;
           biocontroller.text = mybio.length == 0 ? "Write Something interesting about yourself" : mybio;
         return ConstrainedBox(
          
          constraints: BoxConstraints(
           maxHeight: height * 0.19, 
           ),
           child: Material(elevation: 0,
           color: zzz().biobox,
           
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
                      Icon(Icons.notes,color: zzz().icon,size: 20,),
                      SizedBox(width: 5,),
                      Text("Write Something About Yourself!",style: TextStyle(fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold,color: zzz().des),),
                      SizedBox(width: width*0.175,),
                      InkWell(
                onTap: () {
                  bool edittext = context.read<Profileprovider>().edittext;
                  if(edittext){
                    provider.flipTextEditing();
                    provider.updateBio(biocontroller.text);
                    
                  }
                  else{provider.flipTextEditing();}
                  
                },
                child: Container(height: height*0.03,
                child: provider.edittext ? Icon(Icons.edit_note_sharp,size: 30,color: zzz().edit3,): Icon(Icons.edit,color: zzz().edit2,size: 22,),
                )
              )
                    ],
                  )),),
                  Container(height: 1,width: width*0.88,color: zzz().icon,),
           
                 Flexible(
                   child: SingleChildScrollView(
                     child: Container(
                      padding: EdgeInsets.all(10),
                      width: width*0.9,color: Colors.white,
                      child:
                      
                       
                        
                        TextField(
                        controller: biocontroller,
                          maxLines: null, 
                          enabled: edittext,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 13,color: zzz().biotext),
                        )
                       
                     ),
                   ),
                 ),
               ],
             ),
           ),
         );},
       ),

       // OUR INTRESTS
          SizedBox(height: 20,),
          interests(height,width,context),

      //Data
      SizedBox(height: 20,),
      boxs(height, width, length.toString(), "0", "0"),
      SizedBox(height: height*0.05,),
      Container(
        width: width*0.9,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("MY POSTS",style: TextStyle(color: Colors.black,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold,),))),
      myownPosts(height,width),
      SizedBox(height: height*0.05,),
      //LOG OUT
      Logoutbutton()

    ],
  ),
 );
}


Widget interests(double height,double width,BuildContext context){
  
  TextEditingController intrestcontroller = new TextEditingController();
  return Consumer<Profileprovider>(
    builder: (context, value, child) { 
    List<DocumentSnapshot> intrests = value.myinterests;
    return
     Material(
      color: Colors.transparent,
     elevation: 0,
     child: Container(
      
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),color: zzz().intrestbox,),
       child: Column(
        mainAxisSize: MainAxisSize.min,
         children: [
          Container(width: width*0.9,height: height*0.03,
          padding: EdgeInsets.only(left: 10,top: 5),
          child: Row(
            children: [
              Icon(Icons.emoji_objects_sharp,color: zzz().icon,size: 20,),
              SizedBox(width: 5,),
              Text("MY INTERESTS",style: TextStyle(color: zzz().des,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),),
              SizedBox(width: width*0.47,),
              InkWell(
                onTap: () {
                  value.Toggleintrestedit();
                },
                child: Container(height: height*0.03,
                child: value.intrestedit ? Icon(Icons.edit_note_sharp,size: 30,color: zzz().edit3,):  Icon( Icons.edit,color:zzz().edit2,size: 22,),
                )
              )
            ],
          ),
          ),
          SizedBox(height: 5,),
           Container(width: width*0.88,height: 1,color: zzz().icon,),
           SizedBox(height: 5,),
           
           intrestsspace(height,width,context,intrests),
           
           //ADD INTRESTS
          addintrestsspace(height,width,intrestcontroller,context)
         ],
       ),
     ),
    );},
  );
}


Widget intrestsspace(double height,double width,BuildContext context,List<DocumentSnapshot> intrests){
 return intrests.length == 0 ? 
 Container(
        width: width*0.9,height: height*0.05,color: Colors.white,
        child: Center(
          child: Text("NO INTREST MENTIONED",style: TextStyle(fontFamily: MyTheme().loginfont,color: zzz().intrest,fontWeight: FontWeight.bold),),
        ),
        )
 : Container(
        width: width*0.9,height: height*0.09,color: Colors.white,
        child: GridView.builder(
          padding: EdgeInsets.all(5),
          itemCount: intrests.length,
          scrollDirection: Axis.vertical,
         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width*0.27,mainAxisSpacing: 10,crossAxisSpacing: 10,mainAxisExtent: height * 0.03),
         itemBuilder: (context,index){
          final intrest = intrests[index];
          return Material(
            elevation: 0, color: Colors.white,
            child: Center(child: Text(intrest['intrest'],style: TextStyle(color: zzz().intrest,fontFamily: MyTheme().loginfont),)),
          );
         }
         ),
       );
}

Widget addintrestsspace(double height,double width,TextEditingController intrestcontroller,BuildContext context){
  return  context.watch<Profileprovider>().intrestedit == false ? 
  SizedBox(height: 0,width: width*0.9,)
  
   : Row(
         children: [
          SizedBox(width: width*0.01,),
           Container(
            height: height*0.035,
            width: width*0.6,
            child: TextField(
              controller: intrestcontroller,
              style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont),
            )),

            SizedBox(width: width*0.05,),
           Container(
            margin: EdgeInsets.all(4),
             child: InkWell(
              onTap: () {
                context.read<Profileprovider>().buttonanimation();
                context.read<Profileprovider>().AddIntrests(intrestcontroller.text.toUpperCase());
                intrestcontroller.text = "";
              },
                  child: Material(elevation: context.watch<Profileprovider>().buttonelevation,
                  child: Container(
                    height: height*0.035,width: width*0.2,
                    color: zzz().buttonadd,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    child: Text("ADD",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont,fontSize: 14),)),
                  ),
                ),
           ),
         ],
       );
}


Widget boxs(double height,double width,String data1,String data2,String data3){
  return Container(
    height: height*0.15, width: width*0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        box(height, width, "FRIENDS",data1 , zzz().box),
        SizedBox(width: width*0.1,),
        box(height, width, "CUSTOM",data2 , zzz().box),
        SizedBox(width: width*0.1,),
        box(height, width, "DOCUMENTS",data3 , zzz().box),
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
          Text(header,style: TextStyle(color: zzz().boxtext,fontFamily: MyTheme().loginfont,fontSize: 10),),
          SizedBox(height: height*0.002,),
          Container(width: width*0.18,height: 1,color: zzz().boxtext,),
          SizedBox(height: height*0.012,),
          Text(data,style: TextStyle(color: zzz().boxtext,fontFamily: MyTheme().loginfont,fontSize: 25),)
        ],
      ),
    ),
  );
}


class Logoutbutton extends StatefulWidget {
  const Logoutbutton({super.key});

  @override
  State<Logoutbutton> createState() => _LogoutbuttonState();
}

class _LogoutbuttonState extends State<Logoutbutton> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
        elevation: 5,
        color: Colors.transparent,
        child: InkWell(
        onTap: () {
          FirebaseAuth.instance.signOut();
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: zzz().Logoutbutton,),
          width: width*0.3,height: height*0.04,
          child: Center(child: Text("LOG OUT",style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),)),
        ),
      ),
      );
  }
}





Widget myownPosts(double height,double width){
  final myself = FirebaseAuth.instance.currentUser;
  final myuid = myself!.uid;
  return StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('users').doc(myuid).collection('posts').snapshots(), 
  builder: (context,snapshot){
   if(!snapshot.hasData){
    return Container(height: height*0.6,width: width*0.9,
    child: Center(
      child: Text("No Post Added Yet"),
    ),
    );
   }

   else{
    List<DocumentSnapshot> pos = snapshot.data!.docs;
   return  pos.length == 0 ? 
    Container(height: height*0.1,width: width*0.9,
    child: Center(
      child: Text(
        "YOU HAVE NOT UPLOADED ANY POST",
        style: TextStyle(fontFamily: MyTheme().loginfont),
      ),
    ),
    )
   : Container(
    height: height*0.5,width: width*0.94,
    child: ListView.builder(
      itemCount: pos.length,
      itemBuilder: (context,index){
          
          final po = pos[index];
          final obj = po.data() as Map<String,dynamic>;
          return posts(height, width, obj, context);
    }),
   );
  }});}






