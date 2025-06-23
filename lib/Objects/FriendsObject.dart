import 'package:cloud_firestore/cloud_firestore.dart';

class FriendObject{
  final DocumentSnapshot snapshot;
  final String chatid;
  FriendObject({required this.snapshot,required this.chatid});
}