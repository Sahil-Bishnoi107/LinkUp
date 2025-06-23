import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Providers/ChatProvider.dart';
import 'package:linkup/Providers/EditProvider.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/screens/ChattingPage.dart';
import 'package:linkup/screens/TeamInfoPage.dart';
import 'package:linkup/theme/Chattingpagetheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Teamschat extends StatefulWidget {
 final String name;
 final String url;
 final String teamuid;
 const Teamschat({super.key, required this.name, required this.url, required this.teamuid});

 @override
 State<Teamschat> createState() => _TeamsState();
}

class _TeamsState extends State<Teamschat> {
  TextEditingController messagecontroller = new TextEditingController();
  final myself = FirebaseAuth.instance.currentUser;
  ScrollController myscrollController = ScrollController();
  Timer? _typingTimer;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Teamsprovider>().displaymessages(widget.teamuid);
      context.read<Teamsprovider>().LoadTeamPic(widget.teamuid);
     // context.read<ChatProvider>().listenToFriendStatus(widget.frienduid);
     // context.read<ChatProvider>().checkTypingStatus(widget.chatid);
    });
  //  messagecontroller.addListener(HandleTyping);
  }

 /* void HandleTyping(){
    if(!isTyping){isTyping = true;context.read<ChatProvider>().updateTypingStatus(widget.chatid, true);}

    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 2), (){
      isTyping = false;
      context.read<ChatProvider>().updateTypingStatus(widget.chatid, false);
    });
  } */
 @override
 Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;
   final myuid = myself?.uid;
   DocumentSnapshot? myteam = context.read<Teamsprovider>().currentteam;
   
   return Scaffold(
     resizeToAvoidBottomInset: true, 
     backgroundColor: Colors.white,
     body: SafeArea( 
       child: Stack(
         children: [
          Positioned.fill(
            child: Image.asset(xx().bgimage, fit: BoxFit.cover,)),

           Column(
             children: [
               top(height, width, widget.name,widget.url, context,widget.teamuid),
               Expanded( 
                 child: Container(
                   width: width,
                   decoration: BoxDecoration(
                     color: MyTheme().chatpagecolor,
                     borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                   ),
                   child: textspace(width,messagecontroller,widget.teamuid,myuid,height,myscrollController), 
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

Widget top(double height, double width, String name, String myurl, BuildContext context,String teamuid) {
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
                  icon: Icon(Icons.arrow_back,color: xx().backbutton,size: 28,)),
               ),
               ),

               InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Teaminfopage(teamuid: teamuid)));
                },
                 child: Consumer<Teamsprovider>(
                  builder: (context, value, child) => 
                   Container(
                    height: height * 0.06,
                       width: width * 0.16,
                       decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                     child: Container(
                       height: height * 0.06,
                       width: width * 0.15,
                       decoration: BoxDecoration(shape: BoxShape.circle, ),
                       clipBehavior: Clip.hardEdge,
                       child: ClipOval(
                         child: myurl == "" ?  Icon(Icons.groups_2_outlined,color: MyTheme().logincolor,size: 40,) :                     
                          Image.network(myurl,fit: BoxFit.cover,),
                       ),
                     ),
                   ),
                 ),
               ),
               InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Teaminfopage(teamuid: teamuid))),
                 child: Container(
                   margin: EdgeInsets.only(left: 10,top: 12),
                   height: height * 0.08,
                   width: width * 0.38,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: height * 0.012),
                       Text(name, style: TextStyle(color: xx().name, fontFamily: MyTheme().loginfont, fontSize: 15)),
                            
                   /*   Selector<ChatProvider,bool>(
                          selector: (context,provider) => provider.isOnline,
                          builder: (context,value,child) {
                            String typing = value ? "Typing..." : "";
                        return  Text(typing, style: TextStyle(color: Colors.green,fontFamily: MyTheme().loginfont,fontSize: 12),);
                            }) */
                     ],
                   ),
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
                   decoration: BoxDecoration(border: Border.all(color: xx().phone), shape: BoxShape.circle),
                   child: Icon(Icons.call, color: xx().phone, size: 25),
                 ),
               ),
               SizedBox(width: width * 0.025),
               GestureDetector(
                onTap: () => notAvailable(context),
                 child: Container(
                   height: height * 0.06,
                   width: width * 0.12,
                   decoration: BoxDecoration(border: Border.all(color: xx().video), shape: BoxShape.circle),
                   child: Icon(Icons.video_call, color: xx().video, size: 30),
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
 return Consumer<Teamsprovider>( 
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
                   bool showicon = messageidlast != messagidnow;
                   bool bottomcurl = messagidnow != messageidnext;
                  double rad = 30;
                  return Consumer<EditProvider>(
                    builder: (context, value, child) {
                    return

                     InkWell(
                       onLongPress: () {
                        if(message['sender'] == myuid){
                        value.teamenableEdit();
                        if(value.teamedit){messagecontroller.text = message['text'];}
                        else {messagecontroller.text = "";}
                        value.teammessageid = message.id;
                        value.teamid = chatid;    
                        }
                      },
                      onTap: () {
                        if(value.teamedit){messagecontroller.text = "";}
                        value.teamcleardata();
                        
                      },

                       child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                       decoration: BoxDecoration(
                        color: value.teamedit == true  && context.read<EditProvider>().teammessageid == message.id? xx().editbox : Colors.transparent,
                        borderRadius: BorderRadius.circular(15)
                       ),
                        child: Align(
                          alignment: message['sender'] == myuid ? Alignment.centerRight : Alignment.centerLeft,
                          
                            child: Row(
                              mainAxisAlignment: message['sender'] == myuid ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                //Profile pic
                                mydata(message['sender'],myuid,message['pic'],showicon),
                                           
                                           
                                SizedBox(width: 5,),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 333),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15,right: 12,top: 4,bottom: 4),
                                    margin: EdgeInsets.only(top: 2,bottom: 2,right: 5),
                                    decoration: BoxDecoration(color: message['sender'] == myuid ? xx().mymessagecolor : xx().fmessagecolor,
                                    borderRadius: message['sender'] == myuid ?  BorderRadius.only(topLeft: Radius.circular(rad),topRight: showicon ? Radius.circular(rad) : Radius.circular(0),bottomLeft: Radius.circular(rad),bottomRight: bottomcurl ? Radius.circular(rad) : Radius.circular(0)) : BorderRadius.only(topLeft: showicon ? Radius.circular(rad) : Radius.circular(0),topRight: Radius.circular(rad),bottomRight: Radius.circular(rad),bottomLeft: bottomcurl ? Radius.circular(rad) : Radius.circular(0))
                                    ),
                                    child: Text(message['text'], 
                                    style: TextStyle(
                                      fontFamily: MyTheme().loginfont,
                                      color:  message['sender'] == myuid ? xx().mytext : xx().fmytext,fontSize: 18,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                                  ),
                                ),
                              ],
                            
                          ),
                        ),
                                           ),
                     );},
                  );
                },
              ),
             ), 
           
         ),
         sendmessage(width,messagecontroller,context,chatid),
         Container(height: 30, ),
       ],
     );
   },
 );
}

Widget mydata(String messageuid,String? myuid,String url,bool showicon){
  return myuid != messageuid ? 
  
      Container(
      height: 30,width: 30,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(shape: BoxShape.circle),
       child: messageProfilePicWidget(messageuid,url,showicon),
      ) 
    : SizedBox(width: 0,height: 0,);
}


Widget messageProfilePicWidget(String messageuid,String url,bool showicon) {      
        return showicon ? 
        ClipOval(
          child: Image.network(
            url,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
          ),
        ):
        SizedBox.expand();
        
        
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
       GestureDetector(
        onTap: () => notAvailable(context),
        child: Icon(Icons.mic, color: xx().mike, size: 28)),
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
          builder: (context, value, child) => 
           InkWell(
             onTap: () {
              if(value.teamedit){
                value.teamChangeMessage(messagecontroller.text);
              }
              else{
              context.read<Teamsprovider>().SendMessage(messagecontroller.text, chatid);}
              messagecontroller.text = "";
              value.teamcleardata();
            },
            child: Container(
              width: width*0.12, height: 50,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: value.teamedit ? Icon(Icons.edit_document,color: xx().editicon)   :  Icon(Icons.send,color: xx().sendicon,),
              ),
          ),
        ),
          
     ],
   ),
 );
}
