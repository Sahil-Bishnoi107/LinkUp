import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkup/Objects/FriendsObject.dart';
import 'package:linkup/Providers/ChatProvider.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/screens/ChattingPage.dart';
import 'package:linkup/screens/ViewProfile.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

Widget myfriends(double height,double width,List<FriendObject> friends,BuildContext context){
 return  Container(
  height: height*0.675,width: width*0.9,
  child: friendspacewidget(height,width,friends,context),
 );
}






Widget friendspacewidget (double height,double width,List<FriendObject> friends,BuildContext contextz){
  return friends.length == 0 ?
  Center(child: Text("NO FRIENDS FOUND",style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),)):
 
  ListView.builder(
    itemCount: friends.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context,index){
    
    final friend = friends[index];
    return Column(
      children: [
        boxstyle(height, width, friend,contextz),
        SizedBox(height: height*0.01,)
      ],
    );
  })
  ;
}



//Main Box
Widget boxstyle(double height,double width,FriendObject friend,BuildContext context){
  String bio = friend.snapshot.data().toString().contains('UserId') ? friend.snapshot['UserId'] : "I'm using LinkUp";
  

  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chattingpage(name: friend.snapshot["Name"], url: friend.snapshot['profilepic'], chatid: friend.chatid,frienduid: friend.snapshot['Uid'],),));
       context.read<ChatProvider>().clearunread(friend.chatid);
    },
    child: Material(
     elevation: 5,
     child: Container(
      color: Colors.white,
      height: height*0.1,width: width*0.9,
      child: Row(
        children: [
          SizedBox(width: width*0.02,),
          Container(
           height: height*0.08,width: width*0.17,
           decoration: BoxDecoration(shape: BoxShape.circle),
           clipBehavior: Clip.hardEdge,
           child:  friend.snapshot.data().toString().contains('profilepic') ?    
            InkWell(
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: friend.snapshot['Uid'])));
               
              },
              child: ClipOval(
                child: Image.network(friend.snapshot['profilepic'], fit: BoxFit.cover,),
              ),
            )
            : Icon(Icons.person,size: 40,),
          ),
          SizedBox(width: width*0.03,),
          Container(
            height: height*0.06,width: width*0.52,
            margin: EdgeInsets.only(top: 8),
            child : Align(
              alignment: Alignment.centerLeft,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(friend.snapshot["Name"],style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: MyTheme().logincolor,fontWeight: FontWeight.bold),),
              Text(bio,style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10),),
              
               Container(
                width: width*0.52, height: 15,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.chat, color: Colors.grey,size: 10,),
                    ),
              SizedBox(width: 5,),
              Container( width: width*0.3,height: 15,
                      child:lastmessage(friend.chatid, context,friend.snapshot['Uid'])),
                  ],
                ))

            ],
          ))),
          Container(
            child: unread(friend.chatid, context,friend.snapshot['Uid']),
          ),  
        ],
      ),
     ),
    ),
  );
}


Widget lastmessage (String chatid,BuildContext context,String frienduid){
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('Chats').doc(chatid).get(),
   builder: (context,snapshot){
  
      if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){return SizedBox.shrink();}
      else if(!snapshot.hasData || !snapshot.data!.exists){return SizedBox.shrink();}

       else{
        final data = snapshot.data!.data() as Map<String,dynamic>;
      String lastmessage = data.containsKey('lastmessage') ? data['lastmessage'] : "";
        return Text(
        lastmessage,
        style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.green,fontSize: 10),
       );}
   }  
   );
}

Widget unread (String chatid,BuildContext context,String frienduid){
  final x = context.read<ChatProvider>().myself;
  final myuid = x!.uid;

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('unreadmessages').doc(myuid).snapshots(),
   builder: (context,snapshot){
  
      if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){return SizedBox.shrink();}
      else if(!snapshot.hasData || !snapshot.data!.exists){return SizedBox.shrink();}

       else{
        final data = snapshot.data!.data() as Map<String,dynamic>;
        num noofunread = data.containsKey('unread') ? data['unread'] : 0;
        String str = noofunread == 0 ? ""  : noofunread.toString();
        return noofunread == 0 ? 
        lastSeenWidget(frienduid):
        Material(
          elevation: 4,
          shape: const CircleBorder(),
          child: Container(
            height: 30,width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),
            child: Center(
              child: Text(
              str,
              style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.white,fontSize: 15),
                     ),
            ),
          ),
        );}
   }  
   );
}


Widget lastSeenWidget(String uid) {
  final ref = FirebaseDatabase.instance.ref("presence/$uid/last_seen");
  final stateref = FirebaseDatabase.instance.ref("presence/$uid/state");

  return StreamBuilder(
    stream: stateref.onValue,
    builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(height: 20, width: 50);
      }
      
      final state = snapshot.data?.snapshot.value;
    if(state == "online"){
    return  Container(height: 50,width: 60,
            child: Center(
              child: Text("Online",
                   style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.green,fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          );
    }

   else{ return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Container( height: 20,width: 50,
            child: SizedBox.shrink());
        }
    
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Container( height: 50,width: 60,
            child: Center(child: Text("Offline",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 12))));
        }
    
        final value = snapshot.data!.snapshot.value;
        if (value is int) {
          final date = DateTime.fromMillisecondsSinceEpoch(value);
          final now = DateTime.now();
    
          String formattedTime;
          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day) {
            formattedTime = "Today ${DateFormat('h:mm a').format(date)}"; // Today
          } else if (date.difference(now).inDays == -1) {
            formattedTime = "Yesterday, ${DateFormat('h:mm a').format(date)}";
          } else {
            formattedTime = DateFormat('EEEE, h:mm a').format(date);
          }
          
    
          return 
          
           Container(height: 50,width: 60,
            child: Center(
              child: Text("  $formattedTime",
                   style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10)),
            ),
          );
        }
    
        return Container(
          height: 30,width: 50,
          child: Text("Invalid"));
      },
    );}},
  );
}