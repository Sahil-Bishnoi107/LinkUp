import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkup/Providers/introprovider.dart';
import 'package:linkup/screens/LoginPage.dart';
import 'package:provider/provider.dart';

class Intro extends StatefulWidget{
  Intro({super.key});
  @override 
  State<Intro> createState() => _Intro();
}
class _Intro extends State<Intro> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  
  void initState(){
    super.initState();
    // PLAY ANIMATIONS
     Future.delayed(Duration(seconds: 1),(){
      WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<logoprovider>().showlogo();
  });
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this);
      _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
      _controller.forward(); });

      //NAVIGATE TO FIRST PAGE
      Future.delayed(Duration(seconds: 7),(){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context){
    
    return Scaffold(
        body: Center(
          child: mylogo(context)
        ),
    );
  }

  Widget mylogo(BuildContext context){
    final bool iswaiting = context.watch<logoprovider>().waiting;
    return iswaiting ?
         Container()
         :
         FadeTransition(opacity: _controller,
          child:
           Container(margin: EdgeInsets.only(left: 100),
         child: SvgPicture.asset("assets/images/logo.svg", height: 200,width: 200,),)
          );
  }
}