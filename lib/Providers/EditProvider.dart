import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProvider extends ChangeNotifier{
  bool edit = false;
  String messageid = "";
  String chatid = "";
  void enableEdit(){
    edit = !edit;
    notifyListeners();
  }
   //edit 
   Future<void> ChangeMessage(String newtext)async{
    if(newtext == ""){await FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('messages').doc(messageid).delete();
    edit = false;notifyListeners();
    return;
    }


    await FirebaseFirestore.instance.collection('Chats').doc(chatid).collection('messages').doc(messageid).update(
      {
        "text" : newtext 
      }
    );
    messageid = "";chatid = "";edit = false;
    notifyListeners();
    
   }
   void cleardata(){
    messageid = "";chatid = "";edit =false;
    notifyListeners();
   }


  bool teamedit = false;
  String teammessageid = "";
  String teamid = "";
  void teamenableEdit(){
    teamedit = !teamedit;
    notifyListeners();
  }
   //edit 
   Future<void> teamChangeMessage(String newtext)async{
    if(newtext == ""){await FirebaseFirestore.instance.collection('teams').doc(teamid).collection('messages').doc(teammessageid).delete();
    teamedit = false;notifyListeners();
    return;
    }


    await FirebaseFirestore.instance.collection('teams').doc(teamid).collection('messages').doc(teammessageid).update(
      {
        "text" : newtext 
      }
    );
    teammessageid = "";teamid = "";teamedit = false;
    notifyListeners();
    
   }
   void teamcleardata(){
    teammessageid = "";teamid = "";teamedit =false;
    notifyListeners();
   }



  bool groupedit = false;
  String groupmessageid = "";
  String groupid = "";
  void groupenableEdit(){
    groupedit = !groupedit;
    notifyListeners();
  }
   //edit 
   Future<void> groupChangeMessage(String newtext)async{
    if(newtext == ""){await FirebaseFirestore.instance.collection('teams').doc(groupid).collection('messages').doc(groupmessageid).delete();
    groupedit = false;notifyListeners();
    return;
    }


    await FirebaseFirestore.instance.collection('groups').doc(groupid).collection('messages').doc(groupmessageid).update(
      {
        "text" : newtext 
      }
    );
    groupmessageid = "";groupid = "";groupedit = false;
    notifyListeners();
    
   }
   void groupcleardata(){
    groupmessageid = "";groupid = "";groupedit =false;
    notifyListeners();
   }

}