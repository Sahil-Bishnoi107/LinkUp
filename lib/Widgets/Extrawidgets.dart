
import 'package:flutter/material.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Widgets/FriendspageWidgets.dart';
import 'package:linkup/screens/ViewProfile.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';


class RequestButton extends StatefulWidget {
  final String uid;
  final double height;
  final double width;
  final bool requestsent;
  final bool isfriend;

  const RequestButton({
    required this.height,
    required this.width,
    required this.requestsent,
    required this.isfriend,
    required this.uid,
    super.key,
  });

  @override
  State<RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  late bool requested;
  late bool isFriend;

  @override
  void initState() {
    super.initState();
    requested = widget.requestsent;
    isFriend = widget.isfriend;
  }

  @override
  Widget build(BuildContext context) {
    double ele = requested ? 0 : 5;
    String text2 = requested ? "REQUEST SENT" : "ADD FRIEND";
    String text1 = isFriend ? "✓ FRIENDS" : text2;
    Color bgcolor = requested || isFriend
        ? yyy().button1pressed
        : yyy().button1unpressed;
    Color textcolor =
        requested || isFriend ? yyy().button1pressedtext : yyy().button1unpressedtext;

    return InkWell(
      onTap: () async {
        await context.read<Friendsprovider>().SendRequest(widget.uid);
        await getFriendAndRequestStatus(context, widget.uid);
        setState(() {
          requested = true;
        });
      },
      child: Material(
        elevation: ele,
        child: Container(
          height: widget.height * 0.035,
          width: widget.width * 0.28,
          color: bgcolor,
          child: Center(
            child: Text(
              text1,
              style: TextStyle(
                fontFamily: MyTheme().loginfont,
                color: textcolor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ViewProfileButton extends StatefulWidget {
 double height;
  double width;
  String uid;
   ViewProfileButton({super.key,required this.height,required this.width,required this.uid});

  @override
  State<ViewProfileButton> createState() => _ViewProfileButtonState();
}

class _ViewProfileButtonState extends State<ViewProfileButton> {


  double ele = 5;
  void _setElevation(double value) async{
    setState(() {
      ele = value;
    });
    Future.delayed(Duration(milliseconds: 500) ,(){
     setState(() {
      ele = 5;
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = widget.height;final width = widget.width;
    
    return InkWell(  
    onTap: () {
      _setElevation(0);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: widget.uid)));
    },
    child: Material(
      elevation: ele,
      child: Container(
        height: height*0.035,width: width*0.28,
        color: yyy().button2,
        child:Center(
        child: Text("VIEW PROFILE", style: TextStyle(
          fontFamily: MyTheme().loginfont,
          color: yyy().button2text,
          fontSize: 12
        ),),)
      ),
    ),
  );
  }
}






class AcceptButton extends StatefulWidget {
  final double height;
  final double width;
  final String uid;
  const AcceptButton({super.key, required this.height, required this.width,required this.uid});

  @override
  State<AcceptButton> createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isAccepted = true;
        });
        context.read<Friendsprovider>().Accept(widget.uid);
        context.read<Friendsprovider>().Decline(widget.uid);
      },
      child: Material(
        elevation: isAccepted ? 0 : 5,
        
        child: Container(
          height: widget.height * 0.035,
          width: widget.width * 0.28,
          decoration: BoxDecoration(border: Border.all(color: isAccepted ? Colors.green : yyy().button1unpressed),
          color: isAccepted ? const Color.fromARGB(255, 255, 255, 255) : yyy().button1unpressed,
          ),
          child: Center(
            child: Text(
              isAccepted ? "✓ Accepted" : "Accept",
              style: TextStyle(
                fontFamily: MyTheme().loginfont,
                color: isAccepted ? Colors.green:Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeclineButton extends StatefulWidget {
  final double height;
  final double width;
  final String uid;

  const DeclineButton({super.key, required this.height, required this.width,required this.uid});

  @override
  State<DeclineButton> createState() => _DeclineButtonState();
}

class _DeclineButtonState extends State<DeclineButton> {
  bool isDeclined = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isDeclined = true;
        });
        context.read<Friendsprovider>().Decline(widget.uid);
      },
      child: Material(
        elevation: isDeclined ? 0 : 5,
        color: Colors.white,
        child: Container(
          height: widget.height * 0.035,
          width: widget.width * 0.28,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDeclined ? Colors.grey : Colors.white,
            ),
          ),
          child: Center(
            child: Text(
              isDeclined ? "✗ Declined" : "Decline",
              style: TextStyle(
                fontFamily: MyTheme().loginfont,
                color: isDeclined ? const Color.fromARGB(255, 132, 132, 132) : yyy().button1unpressed,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
