import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Logic/Cloudinary.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Teaminfopage extends StatefulWidget {
  String teamuid;
  Teaminfopage({super.key, required this.teamuid});

  @override
  State<Teaminfopage> createState() => _TeaminfopageState();
}

class _TeaminfopageState extends State<Teaminfopage> {
  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<Teamsprovider>();
    provider.showMembers(widget.teamuid);
    provider.LoadTeamPic(widget.teamuid);
  });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DocumentSnapshot? thisteam = context.read<Teamsprovider>().currentteam;
    String teamname = (thisteam != null && thisteam.data().toString().contains('teamname')) ? thisteam['teamname'] : "team";
    String AdminUid = (thisteam != null && thisteam.data().toString().contains('adminUid')) ? thisteam['adminUid'] : "";
    String url = (thisteam != null && thisteam.data().toString().contains('profilepic')) ? thisteam['profilepic'] : "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Stack(
        children: [
          Container(
            height: height,width: width,
            child: Image.asset(z().bg,fit: BoxFit.cover,),
          ),

          Container(
            //color: Colors.white,
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(height: height * 0.07),
                profilepic( context, widget.teamuid,url),
                SizedBox(height: height * 0.025),
                Text(teamname,style: TextStyle(color: z().name,fontSize: 25),),
                SizedBox(height: 70,),
                 AddMembers(height,width,context,widget.teamuid),
                Container(
                  height: height * 0.6,
                  width: width * 0.9,
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.03),
                      Container(width: width * 0.95, height: 1),
                      Container(
                        width: width*0.9,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("TEAM MEMBERS:",style:TextStyle(color: z().headtext,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),)),
                      ),
                      
                      Container(
                        height: height*0.45,width: width*0.9,
                        child: teammembers(height, width,AdminUid)), 
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


Widget AddMembers(double height,double width,BuildContext context,String teamuid){
  TextEditingController txt = new TextEditingController();
 return Container(
  height: height*0.045,width: width*0.9,
  child: Row(
    children: [
     Align(
      alignment: Alignment.centerLeft,
       child: Container(
        height: height*0.045,width: width*0.65,
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(border: Border.all(color:z().inputborder)),
        child: TextField(
          controller: txt,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter User Id",hintStyle: TextStyle(fontFamily: MyTheme().loginfont,color:Colors.grey),
          ),
          style: TextStyle(fontFamily: MyTheme().loginfont,color:z().inputtext),
        ),
       ),
     ),
     SizedBox(width: 20,),
     InkWell(
      onTap: () {
        context.read<Teamsprovider>().AddMemeber(txt.text, teamuid);
        txt.text = "";
      },
      child: Material(
        elevation: 5,
        child: Container(
          width: width*0.2,height: height*0.045, color: z().button,
          child: Center(child: Text("Add",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.white),)),
        ),
      ),
     )
    ],
  ),
 );
}

Widget profilepic( BuildContext context, String teamuid,String url) {
  return InkWell(
    onLongPress: () {
      UploadTeamImage(context, teamuid);
    },
    child: Container(
      height: 120,width: 120,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Consumer<Teamsprovider>(
          
          builder: (context, provider, child) {
            String value = url;
            return value != ""
                ? Image.network(
                    value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.group, size: 40),
                  )
                : Container(
                  height: 120, 
                  width: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: MyTheme().logincolor)),
                  child: Icon(Icons.groups_2_outlined,color: MyTheme().logincolor,size: 60,));
          },
        ),
      ),
    ),
  );
}

Widget teammembers(double height, double width,String AdminUid) {
  return Consumer<Teamsprovider>(builder: (context, provider, child) {
    List<DocumentSnapshot> myteammembers = provider.teammembers;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: myteammembers.length,
      itemBuilder: (context, index) {
        
        final member = myteammembers[index];
        final data = member.data() as Map<String, dynamic>?; 

        if (data == null) return SizedBox.shrink();
        bool isadmin = member['Uid'] == AdminUid;
        print(AdminUid);
        return Material(
          color: Colors.transparent,
          child: Container(
            color: z().list,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(top: 4,bottom: 2),
            height: height * 0.05,
            width: width * 0.9,
            child: Row(
              children: [
                SizedBox(width: width*0.03,),
                Container(
                  height: height * 0.048,
                  width: height * 0.048,
                  child: ClipOval(
                    child: data.containsKey("profilepic") && data['profilepic'] != ""
                        ? Image.network(
                            data['profilepic'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
                          )
                        : Icon(Icons.person),
                  ),
                ),
                SizedBox(width: width * 0.05),
                Container( width: width*0.5,
                  child: Text(
                    data['Name'] ?? "No Name", 
                    style: TextStyle(fontFamily: MyTheme().loginfont, color: z().listtext),
                  ),
                ),
                SizedBox(width: width * 0.05),
                Text(
                  isadmin ? "ADMIN" : "",
                style: TextStyle(fontFamily: MyTheme().loginfont, color:Colors.green),)
              ],
            ),
          ),
        );
      },
    );
  });
}
