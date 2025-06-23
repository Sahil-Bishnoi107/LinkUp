import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/Providers/FriendsProvider.dart';
import 'package:linkup/Providers/Homepageprovider.dart';
import 'package:linkup/Widgets/Extrawidgets.dart';
import 'package:linkup/Widgets/HomepageWidgets.dart';
import 'package:linkup/screens/ViewProfile.dart';
import 'package:linkup/theme/ProfileTheme.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

Widget FriendsHeaderOptions (double width,double height){
  return Consumer<FriendsHeaderOptionProvider>(
    builder: (context,provider,child){
      int selected = provider.selection;
      return Container(
        width: width*0.9, height: height*0.05,
        child: Row(
          children: [
            //OPTION1
             options(selected, 1, width, "PEOPLE", context,height,),
             options(selected, 2, width, "SUGGESTIONS", context,height,),
             options(selected, 3, width, "GROUPS", context,height,)
          ],
        ),
      );
    }
    );
}

Widget options(int selected,int index,double width,String mytext,BuildContext context,double height){
double myelevation = selected == index ? 3 : 0;
Color mycolor = selected == index ? yyy().selectedicon : yyy().unselectedicon;
Color textcolor = selected != index ? yyy().selectedicon : yyy().selectedicontext;
 return InkWell(
              onTap: () {
                
                context.read<FriendsHeaderOptionProvider>().changeSelected(index);  
              },
              child: Material(
                elevation: myelevation,
                color: Colors.transparent,
                child: Container(
                  width: width*0.3, height: height*0.05,
                  color: mycolor,
                  child:Center(
                  child: Text(mytext,style: TextStyle(color: textcolor,fontSize: 15,
                  fontFamily: MyTheme().bottomFont, fontWeight: FontWeight.bold
                  ),)),
                ),
              ),
             );
}
Widget searchbar(TextEditingController mycontroller,IconData myicon, String mytext,double height,double width,double iconsize,BuildContext context){
  return Container(
    height: height*0.06,width: width*0.9,
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: yyy().searchbarborder),
      
    ),
    child: Row(
      children: [
        SizedBox(width: width*0.08,),
        Container(height: height*0.03, color: yyy().searchbarborder, width: 1,),
        SizedBox(width: width*0.03,),
        Container(
          width: width*0.7,
         child: TextField(
          onChanged: (val) { context.read<Friendsprovider>().showSuggestions(val);
                              context.read<Friendsprovider>().groupshowSuggestions(val);
          },
          controller: mycontroller,
          cursorColor: yyy().searchbbartext,
          
          decoration: InputDecoration(border: InputBorder.none,hintText: mytext,hintStyle: TextStyle(fontFamily: MyTheme().loginfont,color: yyy().searchbarhinttext)),
          style: TextStyle(fontFamily: MyTheme().loginfont,color:yyy().searchbbartext),
        )),
        Icon(Icons.search,color: yyy().searchicon,size: iconsize,)
      ],
    ),
  );
}

Future<List<bool>> getFriendAndRequestStatus(BuildContext context, String uid) async {
  final provider = context.read<Friendsprovider>();
  final isFriend = await provider.CheckFriend(uid);
  final isRequested = await provider.CheckRequest(uid);
  return [isFriend, isRequested];
}
Widget friendrequestWidget(double height,double width,String username,String des,String uid,BuildContext context,String pic) {
  return Consumer<Friendsprovider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          future: Future.wait([
            provider.CheckFriend(uid),
            provider.CheckRequest(uid),
          ]),
          builder: (context, AsyncSnapshot<List<bool>> snapshot) {
      if (!snapshot.hasData) {
              return SizedBox(
                height: height * 0.035,
                width: width * 0.28,
                child: Center(child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),
              );
            }    
  else{     
      final isFriend = snapshot.data?[0] ?? false;
      final isRequested = snapshot.data?[1] ?? false;
      
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
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username,style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: yyy().suggestionname,fontWeight: FontWeight.bold),),
            Text(des,style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10),)
          ],
        )),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RequestButton(height: height, width: width, requestsent: isRequested, isfriend: isFriend,uid: uid,),
              SizedBox(height: height*0.005,),
              ViewProfileButton(height: height, width: width, uid: uid)
            ],
          ),
        ),  
      ],
    ),
   ),
  )
  ;}});
});}



Widget friendacceptwidget(double height,double width,DocumentSnapshot user,BuildContext context,String pic){
 return Material(
   elevation: 5,
   color: Colors.transparent,
   child: Container(
    color: yyy().suggestionbox,
    height: height*0.1,width: width*0.9,
    child: Row(
      children: [
        SizedBox(width: width*0.02,),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: user.id)));
          },
          child: Container(
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
        ),
        SizedBox(width: width*0.03,),
        Container(
          height: height*0.06,width: width*0.4,
          margin: EdgeInsets.only(top: 8),
          child: Align(alignment: Alignment.centerLeft,
          child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['Name'],style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 14,color: yyy().suggestionname,fontWeight: FontWeight.bold),),
            Text("Lets be Friends",style: TextStyle(fontFamily: MyTheme().loginfont,color: Colors.grey,fontSize: 10),)
          ],
        ))),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AcceptButton(height: height, width: width,uid: user['Uid'],),
              SizedBox(height: height*0.005,),
              DeclineButton(height: height, width: width,uid: user['Uid'],)
            ],
          ),
        ),  
      ],
    ),
   ),
  );
}