import 'package:flutter/material.dart';
import 'package:linkup/Firebase/Authentication.dart';
import 'package:linkup/Posts/UploadPost.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/BottomBarProvider.dart';
import 'package:linkup/Providers/ChatProvider.dart';
import 'package:linkup/Providers/EditProvider.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Providers/Homepageprovider.dart';
import 'package:linkup/Providers/ProfileProvider.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/Providers/ViewProfileProvider.dart';
import 'package:linkup/Providers/animationsprovider.dart';
import 'package:linkup/Providers/introprovider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyApp();
}
class _MyApp extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => logoprovider()),
    ChangeNotifierProvider(create: (context) => ButtonAnimation()),
    ChangeNotifierProvider(create: (context) => HeaderOptionProvider()),
    ChangeNotifierProvider(create: (context) => BarProvider()),
    ChangeNotifierProvider(create: (context) => FriendsHeaderOptionProvider()),
    ChangeNotifierProvider(create: (context) => Friendsprovider()),
    ChangeNotifierProvider(create: (context) => Profileprovider()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => ViewProfileProvider()),
    ChangeNotifierProvider(create: (context) => Teamsprovider()),
    ChangeNotifierProvider(create: (context) => EditProvider()),
    ChangeNotifierProvider(create: (context) => PostProvider()),
    ChangeNotifierProvider(create: (context) => UploadPost())
    ], 
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authentication(),
    ));
  }
}