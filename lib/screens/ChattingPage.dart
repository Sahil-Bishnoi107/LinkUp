import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Providers/ChatProvider.dart';
import 'package:linkup/Providers/EditProvider.dart';
import 'package:linkup/screens/HomePage.dart';
import 'package:linkup/theme/Chattingpagetheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';




class Chattingpage extends StatefulWidget {
 final String name;
 final String url;
 final String chatid;
 final String frienduid;
 const Chattingpage({super.key, required this.name, required this.url, required this.chatid,required this.frienduid});

 @override
 State<Chattingpage> createState() => _ChattingpageState();
}

class _ChattingpageState extends State<Chattingpage> {
  TextEditingController messagecontroller = new TextEditingController();
  final myself = FirebaseAuth.instance.currentUser;
  ScrollController myscrollController = ScrollController();
  Timer? _typingTimer;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().displaymessages(widget.chatid);
      context.read<ChatProvider>().listenToFriendStatus(widget.frienduid);
      context.read<ChatProvider>().checkTypingStatus(widget.chatid,widget.frienduid);
    });

    messagecontroller.addListener(HandleTyping);
  }

  void HandleTyping(){
    if(!isTyping){isTyping = true;context.read<ChatProvider>().updateTypingStatus(widget.chatid, true);}

    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 2), (){
      isTyping = false;
        if (!mounted) return; // if the context is changed, without this line the app will crash bcs if we switch context,this context here will give us error
      context.read<ChatProvider>().updateTypingStatus(widget.chatid, false);
    });
  }


  
 @override
 Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;
   final myuid = myself?.uid;
   
   return Scaffold(
     resizeToAvoidBottomInset: true, 
     backgroundColor: Colors.white,
     body: SafeArea( 
       child: Stack(
         children: [
          Positioned.fill(
            child: Image.asset(xxx().bgimage, fit: BoxFit.cover,)),

           Column(
             children: [
               top(height, width, widget.name, widget.url, context),
               Expanded( 
                 child: Container(
                   width: width,
                   decoration: BoxDecoration(
                     color: MyTheme().chatpagecolor,
                     borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                   ),
                   child: textspace(width,messagecontroller,widget.chatid,myuid,height,myscrollController), 
                 ),
               ),
             ],
           ),
         ],
       ),
     ),
   );
 }
}

Widget top(double height, double width, String name, String url, BuildContext context) {
 return Container(
   height: height * 0.08,
   width: width,
   child: Row(
     children: [
       Container(
         decoration: BoxDecoration(
           color: MyTheme().chatpagecolor,
           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
         ),
         height: height * 0.08,
         width: width * 0.66,
         child: Row(
           children: [
             SizedBox(width: width * 0.09,
             child: Center(
               child: IconButton(onPressed: (){Navigator.pop(context);},
                icon: Icon(Icons.arrow_back,color: xxx().backbutton,size: 28,)),
             ),
             ),
             Container(
              height: height * 0.06,
                 width: width * 0.16,
                 decoration: BoxDecoration(color: xxx().image,shape: BoxShape.circle,),
               child: Container(
                 height: height * 0.06,
                 width: width * 0.15,
                 decoration: BoxDecoration(shape: BoxShape.circle, ),
                 clipBehavior: Clip.hardEdge,
                 child: ClipOval(
                   child: Image.network(url, fit: BoxFit.cover),
                 ),
               ),
             ),
             Container(
               margin: EdgeInsets.only(left: 10),
               height: height * 0.08,
               width: width * 0.38,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: height * 0.012),
                   Container(
                    height: 21,width: width*0.45,
                    child: Text(name, style: TextStyle(color: xxx().name, fontFamily: MyTheme().loginfont, fontSize: 15))),

                   Container(height: 12,
                     child: Selector<ChatProvider,bool>(selector: (context,provider) => provider.isOnline,builder: (context,value,child) { 
                      String status = value ? "ONLINE" : "OFFLINE";
                      return  Text(status, style: TextStyle(color: value ? xxx().status1 : xxx().status2, fontFamily: MyTheme().loginfont, fontSize: 10));}),
                   ),

                    Consumer<ChatProvider>(
                      builder: (context, provider, child) {
                      return Text(
                      provider.typing ? "Typing..." : "",
                      style: TextStyle(
                      color: xxx().typing,
                      fontFamily: MyTheme().loginfont,
                      fontSize: 12,fontWeight: FontWeight.w500
                       ),
                      );
                       },
                     )
                 ],
               ),
             ),
           ],
         ),
       ),
       Expanded(
         child: Container(
           height: height * 0.08,
           decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
           child: Row(
             children: [
               SizedBox(width: width * 0.03),
               GestureDetector(
                onTap: () => notAvailable(context),
                 child: Container(
                   height: height * 0.06,
                   width: width * 0.12,
                   decoration: BoxDecoration(border: Border.all(color: xxx().phone), shape: BoxShape.circle),
                   child: Icon(Icons.call, color: xxx().phone, size: 25),
                 ),
               ),
               SizedBox(width: width * 0.025),
               GestureDetector(
                onTap: () => notAvailable(context),
                 child: Container(
                   height: height * 0.06,
                   width: width * 0.12,
                   decoration: BoxDecoration(border: Border.all(color: xxx().video), shape: BoxShape.circle),
                   child: Icon(Icons.video_call, color: xxx().video, size: 30),
                 ),
               ),
             ],
           ),
         ),
       ),
     ],
   ),
 );
}

Widget textspace(double width,TextEditingController messagecontroller,String chatid,String? myuid,double height,ScrollController myscrollController) {
 return Consumer<ChatProvider>(
  
   builder: (context, provider, child) {
    List<DocumentSnapshot> messages = provider.chats;

    //to scroll
       WidgetsBinding.instance.addPostFrameCallback((_) {
      if (myscrollController.hasClients) {
       myscrollController.animateTo(
      myscrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
       );
       }
       });

     return Column(
       children: [
        SizedBox(height: height*0.035,),
         Expanded(       
             child: Container(
              width: width*0.98,
              child: ListView.builder(
                controller: myscrollController,
                itemCount: messages.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final message = messages[index];
                 String messagidnow = message['sender'] ?? '';
                  String messageidlast = "";
                  String messageidnext = "";
                  if(index  > 0){messageidlast = messages[index-1]['sender'];}
                  if(index < messages.length-1){messageidnext = messages[index+1]['sender'];}
                   bool topcurl = messageidlast != messagidnow;
                   bool bottomcurl = messagidnow != messageidnext;
                  double rad = 40;
                  return Consumer<EditProvider>(
                    builder: (context, value, child) {
                      
                   return InkWell(
                      onLongPress: () {
                        if(message['sender'] == myuid){
                        value.enableEdit();
                        if(value.edit){messagecontroller.text = message['text'];}
                        else {messagecontroller.text = "";}
                        value.messageid = message.id;
                        value.chatid = chatid;    
                        }
                      },
                      onTap: () {
                        if(value.edit){messagecontroller.text = "";}
                        value.cleardata();
                        
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: value.edit == true  && context.read<EditProvider>().messageid == message.id? xxx().editbox : Colors.transparent,
                          borderRadius: BorderRadius.circular(15)
                        ),
                           
                        child: Align(
                          alignment: message['sender'] == myuid ? Alignment.centerRight : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 360),
                            child: Container(
                      
                              padding: EdgeInsets.only(left: 15,right: 12,top: 4,bottom: 4),
                              margin: EdgeInsets.only(top: 2,bottom: 2,right: 5),
                              decoration: BoxDecoration(color: message['sender'] == myuid ? xxx().mymessagecolor : xxx().fmessagecolor,
                              borderRadius: message['sender'] == myuid ?  BorderRadius.only(topLeft: Radius.circular(rad),topRight: topcurl ? Radius.circular(rad) : Radius.circular(0),bottomLeft: Radius.circular(rad),bottomRight: bottomcurl ? Radius.circular(rad) : Radius.circular(0)):BorderRadius.only(topLeft:topcurl ? Radius.circular(rad) :Radius.circular(0),topRight: Radius.circular(rad),bottomRight: Radius.circular(rad),bottomLeft: bottomcurl ? Radius.circular(rad):Radius.circular(0))
                              ),
                              child: Text(message['text'], 
                              style: TextStyle(
                                fontFamily: MyTheme().loginfont,
                                color:  message['sender'] == myuid ? xxx().mytext : xxx().fmytext,fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );}
                  );
                },
              ),
             ), 
           
         ),
         SizedBox(height: 12,),
         sendmessage(width,messagecontroller,context,chatid),
         Container(height: 24, ),
       ],
     );
   },
 );
}







Widget sendmessage(double width,TextEditingController messagecontroller,BuildContext context,String chatid) {
 return Container(
   padding: EdgeInsets.symmetric(horizontal: 10),
   //color: Colors.white,
   child: Row(
     children: [
      Container( width: width*0.8,  
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
      child: Row( children: [
        SizedBox(width: width*0.025,),
       InkWell(
        onTap: () {
         notAvailable(context);
        },
        child: Icon(Icons.mic, color: xxx().mike, size: 28)),
       VerticalDivider(color: MyTheme().chatpagecolor),
       Expanded(
         child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller : messagecontroller,
           decoration: InputDecoration(  
             hintText: 'Type a message...',
             border: InputBorder.none,
           ),
           style: TextStyle(fontFamily: MyTheme().loginfont),
         ),
       ),
       
       ]),
        ),
        SizedBox(width: 10,),

        Consumer<EditProvider>(
          builder: (context, value, child) {
          
          return InkWell(
            onTap: () {
              if(value.edit){
                value.ChangeMessage(messagecontroller.text);
              }
              else{
              context.read<ChatProvider>().sendMessage(messagecontroller.text, chatid);}
              messagecontroller.text = "";
            },
            child: Container(
              width: width*0.12, height: 50,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child:value.edit ? Icon(Icons.edit_document,color: xxx().editicon)   :  Icon(Icons.send,color: xxx().sendicon,),
              ),
          );}
        ),     
     ],
   ),
 );
}



void notAvailable(BuildContext context){
   ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("This feature is not available right now!",style: TextStyle(color: Colors.black,fontFamily: MyTheme().loginfont),),
           duration: Duration(seconds: 2),
           backgroundColor: Colors.white,
           )
          );
}