import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Providers/TeamsProvider.dart';
import 'package:linkup/screens/TeamsChat.dart';
import 'package:provider/provider.dart';
import 'package:linkup/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  void initState() {
    super.initState();
      Future.microtask(() {
    context.read<Teamsprovider>().showTeams();
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
      
         Consumer<Teamsprovider>(builder: (context,provider,child){
          final teams = provider.teams;
          return teams.length == 0 ?
          Center(child: Text("NO TEAM FOUND",style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontWeight: FontWeight.bold),)):
         
          ListView.builder(
        itemCount: teams.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index){
        
        final team = teams[index];


        return Column(
          children: [
            boxstyle(height, width, team,context,teams.length.toString()),
            SizedBox(height: height*0.01,)
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


Widget boxstyle(double height,double width,DocumentSnapshot team,BuildContext context, String bio){
  
final Map<String, dynamic>? data = team.data() as Map<String, dynamic>?;

String url = data?.containsKey('profilepic') == true ? data!['profilepic'] : "";
String teamuid = data?.containsKey('teamuid') == true ? data!['teamuid'] : "";




  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Teamschat(name: team['teamname'], url:url , teamuid: team['teamuid'])));
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
              Text(team["teamname"],style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: MyTheme().logincolor,fontWeight: FontWeight.bold),),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('teams').doc(team.id).collection('members').get(),
                builder: (context,snapshot) {
                  if(!snapshot.hasData){return SizedBox.shrink();}
                  else{
                    final members = snapshot.data!.docs.length;
                  return Text( "$members Members",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10),);}
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
                      child: lastmessage(teamuid, context)),                    
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



Widget lastmessage (String teamuid,BuildContext context){
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('teams').doc(teamuid).snapshots(),
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
   showModalBottomSheet(context: context,
   isScrollControlled: true, 
   builder: (context) => 
     Container(
      height: height*0.6,width: width,
      child: Column(
        children: [
          SizedBox(height: height*0.02,),
          Text("CREATE NEW TEAM",style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: height*0.07,),
          Container(
            width: width*0.7,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: MyTheme().logincolor),borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: txt,
             decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your team name here!",
              hintStyle: TextStyle(color: Colors.grey,fontFamily: MyTheme().loginfont)
             ),
             style: TextStyle(color: MyTheme().logincolor,fontFamily: MyTheme().loginfont),
            ),
          ),
          SizedBox(height: height*0.05,),
          InkWell(
            onTap: () {
              context.read<Teamsprovider>().createTeam(txt.text);
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
          )
        ],
      ),
     )
   );
}
