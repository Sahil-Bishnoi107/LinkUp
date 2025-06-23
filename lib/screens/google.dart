import 'package:flutter/material.dart';
import 'package:linkup/Firebase/Signin.dart';
import 'package:linkup/Widgets/LoginOptions.dart';
import 'package:linkup/Providers/animationsprovider.dart';
import 'package:linkup/screens/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:linkup/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Google extends StatefulWidget {
  final User me;
  const Google({required this.me, super.key});

  @override
  State<Google> createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  final TextEditingController gname = TextEditingController();
  final TextEditingController gid = TextEditingController();

  Future<void> handleProceed() async {
    final name = gname.text.trim();
    final userid = gid.text.trim();
    final email = widget.me.email ?? "";

    if (name.isEmpty || userid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name and UserID cannot be empty")),
      );
      return;
    }

    try {
      context.read<ButtonAnimation>().clicked();
      await createnewuser(widget.me.uid, name, userid, email);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Homepage()),
        );
      }
    } catch (e) {
      print("❌ Error creating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create account. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/bgimages/loginpage.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.3,
                  child: Center(
                    child: Text(
                      "ONE LAST STEP",
                      style: TextStyle(
                        color: MyTheme().logincolor,
                        fontFamily: MyTheme().loginfont,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                LoginOption("NAME", height, width, Icons.account_circle_rounded, gname),
                SizedBox(height: height * 0.01),
                LoginOption("USERID", height, width, Icons.insert_drive_file_sharp, gid),
                SizedBox(height: height * 0.05),
                InkWell(
                  onTap: handleProceed,
                  child: Material(
                    elevation: context.watch<ButtonAnimation>().elevation,
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.9,
                      color: context.watch<ButtonAnimation>().buttoncolor,
                      child: Center(
                        child: Text(
                          "PROCEED",
                          style: TextStyle(
                            color: context.watch<ButtonAnimation>().textcolor,
                            fontFamily: MyTheme().loginfont,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
