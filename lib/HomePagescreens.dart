import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Objects/FriendsObject.dart';
import 'package:linkup/Posts/Groups.dart';
import 'package:linkup/Posts/postspage.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/ChatProvider.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Providers/Homepageprovider.dart';
import 'package:linkup/Widgets/Friends.dart';
import 'package:linkup/Widgets/FriendspageWidgets.dart';
import 'package:linkup/Widgets/HomepageWidgets.dart';
import 'package:linkup/Widgets/Teams.dart';
import 'package:linkup/Widgets/friendsgroups.dart';
import 'package:linkup/screens/Profile.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Friendsprovider>().listenToFriends();
      context.read<ChatProvider>().updateStatus();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
           height: height,width: width,
           child: Column(
            children: [
               SizedBox(height: height*0.04,),
              //TOP PART
              Row(
                children: [
                 SizedBox(width: width*0.05,),
                 HeadingText(20, height, width, MyTheme().logincolor),
                 SizedBox(width: width*0.33,),
               //clickIcon(Icons.search, MyTheme().logincolor, height, width),
                 SizedBox(width: width*0.03,),
              //   clickIcon(Icons.settings, Colors.blueGrey, height, width)
                ],
              ),
              SizedBox(height: height*0.02,),
              //SWITCH OPTIONS
              HeaderOptions(width, height),
              SizedBox(height: height*0.025,),
              Container(height: 1.5,width: width*0.9,color: MyTheme().logincolor,),


              // FriendsList
              Selector<HeaderOptionProvider,int>(
                selector: (context,provider) => provider.selected,
                builder: (context,value,child) => middlepart(height, width,context,value)
                )

            ],
           ),
      );
  }
}



Widget middlepart(double height, double width,BuildContext context,int selected){
  if(selected == 1){
   return Consumer<Friendsprovider>(builder: (context,provider,child){
                List<FriendObject> myfriendlist = provider.friends;
              return myfriends(height, width, myfriendlist,context);
              }
             );}

  if(selected == 2){
   return Teams();
             }  

  else {return Groups();}                    
}





//Profile
class PROFILE extends StatefulWidget {
  const PROFILE({super.key});

  @override
  State<PROFILE> createState() => _PROFILEState();
}

class _PROFILEState extends State<PROFILE> {
  @override
  Widget build(BuildContext context) {
    return Profilepage();
  }
}





//Feed
class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Posts();
  }
}




//Friends
class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final TextEditingController mycontroller = new TextEditingController();
   @override
  void initState() {
    super.initState();
    context.read<PostProvider>().getGroups();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Friendsprovider>().listenToFriendRequests();
      
    });
  }
  @override

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    

    return Stack(
      children: [
        Container(
          height: height,width: width,
          child: Image.asset(yyy().bg,fit: BoxFit.cover,),
        ),
        Container(
          height: height,width: width,
       //  color: yyy().selectedicontext,
        child: Column(
          children: [
            SizedBox(height: height*0.07,),
            searchbar(mycontroller, Icons.search, "Search Here!", height, width, 25,context),
            SizedBox(height: height*0.02,),
            FriendsHeaderOptions(width, height),
            SizedBox(height: height*0.03,),
           // Container(height: 1,color: MyTheme().logincolor,width: width*0.9,),
            SizedBox(height: height*0.01,),
            Consumer<Friendsprovider>(builder: (context, provider, child){
             List<DocumentSnapshot> options = context.watch<Friendsprovider>().suggestions;
             List<DocumentSnapshot> requests = context.watch<Friendsprovider>().friendrequests;
             List<DocumentSnapshot> groupoption = context.watch<Friendsprovider>().groupsuggestions;
             List<DocumentSnapshot> mygroups = context.watch<PostProvider>().joinedgroups;
             return  Container(
              height: height*0.6,width: width*0.9,
              child:  Consumer<FriendsHeaderOptionProvider>(builder: (context, value, child) {
                int selected = value.selection;
             if(selected == 2) {return suggestions();}
             else if(selected == 3){return groupssearchlist(groupoption,height,width,mycontroller,mygroups);}
             
             else{ return searchlist(options,height,width,mycontroller,requests);}},
               ),
            );})
          ],
        ),
        ),
      ],
    );
  }
}

Widget searchlist(List<DocumentSnapshot> options,double height,double width,TextEditingController mycontroller,List<DocumentSnapshot> requests){
  return mycontroller.text.isEmpty ? 
   requestspace(options, height, width, mycontroller, requests)
   :
   ListView.builder(
           itemCount: options.length,
           scrollDirection: Axis.vertical,
           itemBuilder: (context, index)  {   
             String username = options[index]['Name']; 
             String pic = options[index].data().toString().contains('profilepic') ? options[index]['profilepic'] : "notfound";
             return Column(
              children: [
             friendrequestWidget(height,width,username,"I'm using LinkUp",options[index]['Uid'],context,pic),
             SizedBox(height: height*0.012,)
             ]);
           },
          );
}

Widget requestspace(List<DocumentSnapshot> options,double height,double width,TextEditingController mycontroller,List<DocumentSnapshot> requests){
  return requests.length == 0 ? 
  Container(
    child: Center(
      child: Text("NO PENDING REQUESTS",style: TextStyle(fontFamily: MyTheme().loginfont,color: yyy().pendingrequestscolor,fontWeight: FontWeight.bold),),
    ),
  )


  : 
   ListView.builder(
    itemCount: requests.length,
    scrollDirection: Axis.vertical,
    itemBuilder:(context, index)  {   
             String username = requests[index]['Name']; 
             String pic = requests[index].data().toString().contains('profilepic') ? requests[index]['profilepic'] : "notfound";
             return Column(
              children: [
             friendacceptwidget(height,width,requests[index],context,pic),
             SizedBox(height: height*0.012,)
             ]);
           },

    );
    }


  Widget groupssearchlist(List<DocumentSnapshot> groupoption,double height,double width,TextEditingController mycontroller,List<DocumentSnapshot> mygroups){
     return mycontroller.text.isEmpty ? 
   Center(
    child: Text("Search group here",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont),),
   )
   :
   ListView.builder(
           itemCount: groupoption.length,
           scrollDirection: Axis.vertical,
           itemBuilder: (context, index)  {   
             bool isgroup = false;
             String username = groupoption[index].data().toString().contains('groupname') ? groupoption[index]['groupname'] : "group"; 
             String pic = groupoption[index].data().toString().contains('profilepic') ? groupoption[index]['profilepic'] : "notfound";
             String groupid = groupoption[index].data().toString().contains('groupid') ? groupoption[index]['groupid'] : "notfound";
             for(var v in mygroups){
              if(v.id == groupid){isgroup = true;}
             }
             return Column(
              children: [
             grouprequestWidget(height,width,pic,username,groupid,isgroup),
             SizedBox(height: height*0.012,)
             ]);
           },
          );
  }



  Widget grouprequestWidget(double height, double width, String pic,String groupname,String groupid,bool isgroup){
    return Material(
   elevation: 5,
   color: Colors.transparent,
   child: Container(
    color: yyy().suggestionbox,
    height: height*0.1,width: width*0.9,
    child: Row(
      children: [
        SizedBox(width: width*0.02,),
        Container(
         height: height*0.08,width: width*0.15,
         decoration: BoxDecoration(shape: BoxShape.circle),
         clipBehavior: Clip.hardEdge,
         child: (pic != null && pic.trim().isNotEmpty && Uri.tryParse(pic)?.hasAbsolutePath == true)
         ? ClipOval(
          child: Image.network(
            pic,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.abc),
          ),
        )
      : Icon(Icons.person),
        ),
        SizedBox(width: width*0.03,),
        Container(
          height: height*0.06,width: width*0.4,
        child:  Align( 
          alignment: Alignment.centerLeft,
          child : Text(groupname,style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: yyy().suggestionname,fontWeight: FontWeight.bold),),)),
          
          joingroupbutton(groupid: groupid ,isgroup: isgroup,)  
      ],
    ),
   ),
  );
  } 


  class joingroupbutton extends StatefulWidget {
    String groupid;
    bool isgroup;
   joingroupbutton({super.key,required this.groupid,required this.isgroup});

  @override
  State<joingroupbutton> createState() => joingroupbuttonState();
}

class joingroupbuttonState extends State<joingroupbutton> {
  
  bool isckicked = false;
  
  void changes(){
    setState(() {
      isckicked = true;
    });
  }
  @override
  Widget build(BuildContext context) {
  isckicked = widget.isgroup;
    
      
      
      return InkWell(
        onTap: () {
          context.read<PostProvider>().joinGroups(widget.groupid);
          changes();
        },
        child: Material(
          elevation: isckicked ? 0 : 5,
          color: Colors.transparent,
          child: Container(
            height: 30,width: 100,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: isckicked ? Colors.transparent: Colors.black,border: Border.all(width: isckicked ? 1 : 0,color: isckicked ? Colors.green : Colors.black)),
            child: Center(child: Text(isckicked ? "JOINED" : "JOIN GROUP", style: TextStyle(color: isckicked ? Colors.green : Colors.white,fontFamily: MyTheme().loginfont,fontSize: 12),)),
          ),
        ),
      );
    
  }
}