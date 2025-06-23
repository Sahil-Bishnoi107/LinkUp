import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/theme/theme.dart';

class suggestions extends StatefulWidget {
  const suggestions({super.key});

  @override
  State<suggestions> createState() => _suggestionsState();
}

class _suggestionsState extends State<suggestions> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This feature will be available soon",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont),),
    );
  }
}



class groups extends StatefulWidget {
  const groups({super.key});

  @override
  State<groups> createState() => _groupsState();
}

class _groupsState extends State<groups> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}