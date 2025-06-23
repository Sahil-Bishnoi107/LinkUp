import 'package:flutter/material.dart';
import 'package:linkup/Logic/HomePageLogic.dart';
import 'package:linkup/Widgets/HomepageWidgets.dart';
import 'package:linkup/theme/Chattingpagetheme.dart';
import 'package:linkup/theme/theme.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: mybar(context),
      body: CurrentScreen(context)
    );
  }
}