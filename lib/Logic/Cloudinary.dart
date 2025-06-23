import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkup/Posts/UploadPost.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/ProfileProvider.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

Future<void> UploadImage(BuildContext context) async{
  final picker = ImagePicker();
  final PickedFile = await picker.pickImage(source: ImageSource.gallery);
  if(PickedFile == null){return;}
  final cloudinary = CloudinaryPublic('dxh6lmkrf', 'unsigned_preset',cache: false);
   try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        PickedFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    final myself = FirebaseAuth.instance.currentUser;
    final myuid = myself?.uid;
    await FirebaseFirestore.instance.collection('users').doc(myuid).collection('profile').doc('pic').set(
    {'picUrl' : response.secureUrl}
    );  
    await FirebaseFirestore.instance.collection('users').doc(myuid).update(
    {'profilepic' : response.secureUrl}
    );
    context.read<Profileprovider>().immediatelyupadte(response.secureUrl);
}
catch(e){
  print("Couldnt upload");
}
}




Future<void> UploadTeamImage(BuildContext context,String teamuid) async{
  final picker = ImagePicker();
  final PickedFile = await picker.pickImage(source: ImageSource.gallery);
  if(PickedFile == null){return;}
  final cloudinary = CloudinaryPublic('dxh6lmkrf', 'unsigned_preset',cache: false);
   try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        PickedFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    final myself = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('teams').doc(teamuid).update(
    {'profilepic' : response.secureUrl}
    );
    context.read<Teamsprovider>().instantupdateteampic(response.secureUrl);
}
catch(e){
  print("Couldnt upload");
}
}

Future<void> UploadGroupImage(BuildContext context,String groupid) async{
  final picker = ImagePicker();
  final PickedFile = await picker.pickImage(source: ImageSource.gallery);
  if(PickedFile == null){return;}
  final cloudinary = CloudinaryPublic('dxh6lmkrf', 'unsigned_preset',cache: false);
   try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        PickedFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    final myself = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('groups').doc(groupid).update(
    {'profilepic' : response.secureUrl}
    );
    context.read<PostProvider>().instantupdateteampic(response.secureUrl);
}
catch(e){
  print("Couldnt upload");
}
}

Future<void> UploadPostImage(BuildContext context) async{
  final picker = ImagePicker();
  final PickedFile = await picker.pickImage(source: ImageSource.gallery);
  if(PickedFile == null){return;}
  final cloudinary = CloudinaryPublic('dxh6lmkrf', 'unsigned_preset',cache: false);
   try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        PickedFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    context.read<UploadPost>().posturl = response.secureUrl;
    context.read<UploadPost>().update();
}
catch(e){
  print("Couldnt upload");
}
}