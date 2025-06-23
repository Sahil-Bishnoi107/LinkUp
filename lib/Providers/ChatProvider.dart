import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ChatProvider extends ChangeNotifier{
  final myself = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> chats = [];
  final database = FirebaseDatabase.instance;


  //send message
  Future<void> sendMessage(String text,String chatid) async{
    if (text == ""){return;}
    final myuid = myself?.uid; 
   String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
   await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatid)
        .collection('messages')
        .doc(timestampId)
        .set({
      'text': text,
      'sender': myuid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    notifyListeners();
    await FirebaseFirestore.instance.collection('Chats').doc(chatid).update({
     'lastmessage': text,
    'timestamp': FieldValue.serverTimestamp(),
   });
   final obj = await FirebaseFirestore.instance.collection("Chats").doc(chatid).get();
   String frienduid = myuid == obj['uid1'] ? obj['uid2'] : obj['uid1'];
   updateUnread(chatid, frienduid);
  }


  //displaymessages
  void displaymessages(chatId){
    
    FirebaseFirestore.instance.collection('Chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots().listen((snapshot){ 
    chats = snapshot.docs;
    notifyListeners();
    });
  }

  //Check User Status
  void updateStatus(){
    final myuid = myself?.uid; 
    final userRef = database.ref("presence/$myuid");
    userRef.set({
    "state": "online",
    "last_seen": ServerValue.timestamp,
  });

  userRef.onDisconnect().set({
    "state": "offline",
    "last_seen": ServerValue.timestamp,
  });
  }

  bool isOnline = true;
  StreamSubscription<DatabaseEvent>? _statusSub;

  void setOnlineStatus(bool status) {
    isOnline = status;
    notifyListeners();
  }

  void listenToFriendStatus(String friendUid) {
    _statusSub?.cancel(); 

    final ref = FirebaseDatabase.instance.ref('presence/$friendUid');

    _statusSub = ref.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null || data['state'] == null) {
        setOnlineStatus(false);
        return;
      }

      setOnlineStatus(data['state'] == 'online');
    });
  }

  

  //check typing Status
  bool typing = false;
   Future<void> updateTypingStatus(String ChatId,bool setbool) async{
    final myuid = myself?.uid; 
    await FirebaseFirestore.instance.collection('Chats').doc(ChatId).collection('typingStatus').doc(myuid).set({
    'typing' : setbool,'uid' : myuid
    });
   }
   void checkTypingStatus(String ChatId,String frienduid){
    final myuid = myself?.uid; 
    
    FirebaseFirestore.instance.collection('Chats').doc(ChatId).collection('typingStatus').doc(frienduid).snapshots().listen((snapshot){
     typing = snapshot['typing'];notifyListeners();
    });
    
   }



   // Unread messages
   Future<void> updateUnread(String chatid,String frienduid) async{
       final f = await FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('unreadmessages').doc(frienduid).get();
       num unread = 0;
       if(f.data() != null){unread = unread +   f['unread'];}
       await FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('unreadmessages').doc(frienduid).set({
         "unread":unread
       });
   }
   Future<void> clearunread(String chatid)async{
     final myuid = myself?.uid; 
    await FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('unreadmessages').doc(myuid).set({
         "unread": 0
       });
       notifyListeners();
   }
}