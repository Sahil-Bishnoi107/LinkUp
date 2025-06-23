import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Posts/GroupChat.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/screens/TeamsChat.dart';
import 'package:provider/provider.dart';
import 'package:linkup/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Groups extends StatefulWidget {
   Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  void initState() {
    super.initState();
      Future.microtask(() {
    context.read<PostProvider>().showGroups();
  });
     
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.65,width: width*0.9,
      child: Stack(
        children: [
      
         Consumer<PostProvider>(builder: (context,provider,child){
          final groups = provider.mygroups;
          return groups.length == 0 ?
          Center(child: Text("NO GROUP FOUND",style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),)):
         
        ListView.builder(
        itemCount: groups.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index){
        
        final group = groups[index];
        return Column(
          children: [
            boxstyle(height, width, group,context,groups.length.toString()),
            SizedBox(height: height*0.01,),
          ],
        );
          })
          ;
        }),
      
        
          
           Align(
            alignment: Alignment.bottomRight,
            child: Material(
              elevation: 5,
               shape: const CircleBorder(),
              child: InkWell(
                onTap: () {         
            BottomSheet(context,height,width);
                },
                child: Container(
                  height: 70,width: 70,
                  decoration: BoxDecoration(color: MyTheme().logincolor,shape: BoxShape.circle),
                  child: Icon(Icons.add,size: 40,color: Colors.white,),
                ),
              ),
            )),
        
      ]),
    );
  }
}


Widget boxstyle(double height,double width,DocumentSnapshot group,BuildContext context, String bio){
  
final Map<String, dynamic>? data = group.data() as Map<String, dynamic>?;

String url = data?.containsKey('profilepic') == true ? data!['profilepic'] : "";
String groupid = data?.containsKey('groupid') == true ? data!['groupid'] : "";




  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Groupchat(name: group['groupname'], url: url, groupid: groupid)));
    },
    child: Material(
     elevation: 5,
     child: Container(
      color: Colors.white,
      height: height*0.1,width: width*0.9,
      child: Row(
        children: [
          SizedBox(width: width*0.02,),
          Container(
           height: height*0.08,width: width*0.17,
           decoration: BoxDecoration(shape: BoxShape.circle),
           clipBehavior: Clip.hardEdge,
           child:     
            InkWell(
             // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: friend.snapshot['Uid']))),
              child: ClipOval(
                child: Image.network(url, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.grade),
                ),
              ),
            )
            
          ),
          SizedBox(width: width*0.03,),
          Container(
            height: height*0.06,width: width*0.4,
            margin: EdgeInsets.only(top: 8),
            child : Align(
              alignment: Alignment.centerLeft,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group["groupname"],style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: MyTheme().logincolor,fontWeight: FontWeight.bold),),
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('groups').doc(groupid).collection('members').get(),
                builder: (context,snapshot) {
                  if(!snapshot.hasData){return SizedBox.shrink();}
                  else{
                    final m = snapshot.data!.docs.length;
                  return Text( "$m Members",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10),);}
                }
              ),
 
              //Last Message
              Container(
                width: width*0.4, height: 15,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.chat, color: Colors.grey,size: 10,),
                    ),
              SizedBox(width: 5,),
              Container( width: width*0.3,height: 15,
                      child: lastmessage(groupid, context)),                    
                  ],
                ))
            ],
          ))),
          Container(
            // SPACE FOR NEW MESSAGES
          ),  
        ],
      ),
     ),
    ),
  );
}



Widget lastmessage (String groupid,BuildContext context){
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('groups').doc(groupid).snapshots(),
   builder: (context,snapshot){  
      if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){return SizedBox.shrink();}
      else if(!snapshot.hasData || !snapshot.data!.exists){return SizedBox.shrink();}

       else{
        final data = snapshot.data!.data() as Map<String,dynamic>;
      String lastmessage = data.containsKey('lastmessage') ? data['lastmessage'] : "";
        return Text(
        lastmessage,
        style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.green,fontSize: 10),
       );}
   }  
   );
}


void BottomSheet(BuildContext context,double height,double width){
  TextEditingController txt = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
   showModalBottomSheet(context: context, 
   isScrollControlled: true,
   builder: (context) => 
     SizedBox(
      height: height*0.7,width: width,
      child: Column(
        children: [
          SizedBox(height: height*0.02,),
          Text("CREATE NEW GROUP",style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: height*0.07,),
          Container(
            width: width*0.7,height: 50,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: MyTheme().logincolor),borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: txt,
             decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your group name here!",
              hintStyle: TextStyle(color: Colors.grey,fontFamily: MyTheme().loginfont)
             ),
             style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont),
            ),
          ),
          SizedBox(height: height*0.02,),
          Container(
            width: width*0.7, height: 50,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: MyTheme().logincolor),borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: txt2,
             decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your groupid here!",
              hintStyle: TextStyle(color: Colors.grey,fontFamily: MyTheme().loginfont)
             ),
             style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont),
            ),
          ),
          SizedBox(height: height*0.05,),
          InkWell(
            onTap: () {
              context.read<PostProvider>().createGroup(txt2.text,txt.text);
              Navigator.pop(context);
            },
            child: Material(
              elevation: 10,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(color: MyTheme().logincolor,borderRadius: BorderRadius.circular(5)),
                height: height*0.05,width: width*0.4,
                child: Center(child: Text("CREATE",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont,fontSize: 20),)),
              ),
            ),
          ),
          Container(height: height*0.3,width: width,)
        ],
      ),
     )
   );
}
