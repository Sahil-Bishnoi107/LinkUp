import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Logic/Cloudinary.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Groupinfopage extends StatefulWidget {
  String groupid;
   Groupinfopage({super.key, required this.groupid});

  @override
  State<Groupinfopage> createState() => _GroupinfopageState();
}

class _GroupinfopageState extends State<Groupinfopage> {
  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<PostProvider>();
    provider.showMembers(widget.groupid);
    provider.LoadTeamPic(widget.groupid);
  });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DocumentSnapshot? thisgroup = context.read<PostProvider>().currentgroup;
    String groupname = (thisgroup != null && thisgroup.data().toString().contains('groupname')) ? thisgroup['groupname'] : "Group";
    String AdminUid = (thisgroup != null && thisgroup.data().toString().contains('admin')) ? thisgroup['admin'] : "";
    String url = (thisgroup != null && thisgroup.data().toString().contains('profilepic')) ? thisgroup['profilepic'] : "";
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
                profilepic( context, thisgroup,url),
                SizedBox(height: height * 0.025),
                Text(groupname,style: TextStyle(color: z().name,fontSize: 25),),
                SizedBox(height: 70,),
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
                          child: Text("GROUP MEMBERS:",style:TextStyle(color: z().headtext,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),)),
                      ),
                      
                      Container(
                        height: height*0.45,width: width*0.9,
                        child: teammembers(height, width,AdminUid)
                      ), 
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
Widget profilepic( BuildContext context, DocumentSnapshot? group,String url) {
 if(group != null)  print(group.id);
  return InkWell(
    onLongPress: () {
    if(group != null)  UploadGroupImage(context, group.id );
    if(group != null) context.read<PostProvider>().instantupdateteampic(group.id);
    },
    child: Container(
      height: 120,width: 120,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Consumer<PostProvider>(
          
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
  return Consumer<PostProvider>(builder: (context, provider, child) {
    List<DocumentSnapshot> mygroupmembers = provider.groupmembers;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mygroupmembers.length,
      itemBuilder: (context, index) {
        
        final member = mygroupmembers[index];
        final data = member.data() as Map<String, dynamic>?; 

        if (data == null) return SizedBox.shrink();
        bool isadmin = member['Uid'] == AdminUid;
        
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
