import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkup/Posts/CreatePosts.dart';
import 'package:linkup/Posts/UploadPost.dart';
import 'package:linkup/Posts/postsprovider.dart';
import 'package:linkup/screens/ChattingPage.dart';
import 'package:linkup/screens/ViewProfile.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  void initState() {
    super.initState();
    context.read<PostProvider>().viewposts();
    context.read<PostProvider>().getlikedposts();

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromRGBO(250, 249, 246, 1),
      height: height,width: width,
      child: Column(
        children: [
          
          top(height,width,context),
         // header(height, width),
         //SizedBox(height: 20,),
          postspace(height, width)
        ],
      ),
    );
  }
}


Widget top(double height,double width,BuildContext context){
  return Material(
    elevation: 2,
    color: Colors.white,
    child: Container(
    padding: EdgeInsets.only(top: height*0.055),
     alignment: Alignment.topLeft,
      height: height*0.14,width: width,
      child: Row(
        children: [
        SizedBox(width: width*0.05),
        Container( height: height*0.07,width: width*0.16,
        clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle),
                child:   Image.network("https://res.cloudinary.com/dxh6lmkrf/image/upload/v1749819213/n09qxoz1ka10nyelpury.jpg",fit: BoxFit.cover,)
        ),
        SizedBox(width: width*0.03,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Createposts())),
          child: Container(height: height*0.046, 
          decoration: BoxDecoration(color: MyTheme().logincolor,borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(horizontal: width*0.09),
          child: Center(child: Text("ADD POST",style: TextStyle(color: Colors.white,fontFamily: MyTheme().loginfont),)),
          ),
        ),
        SizedBox(width: width*0.2,),
      /*  Container(width: width*0.11,height: height*0.045,
        child: SvgPicture.asset("assets/images/saved-svgrepo-com.svg",color: Colors.black,height: 20,width: 20,),
        ),*/
        
        SizedBox(width: width*0.04,),
        GestureDetector(
          onTap: () => notAvailable(context),
          child: Container(width: width*0.1,height: height*0.04,
          child: SvgPicture.asset("assets/images/message-square-lines-svgrepo-com (1).svg",color: Colors.black,height: 20,width: 20,),
          ),
        ),
        ],
      ),
    )
  );
}


Widget postspace(double height,double width){
  return Consumer<PostProvider>(
    builder: (context, value, child) {
      List<DocumentSnapshot> postlist = value.posts;
      Future<void> _refreshposts() async{
        print("refreshed");
        context.read<PostProvider>().viewposts();
    context.read<PostProvider>().getlikedposts();
      }
    return Container(
     // margin: EdgeInsets.only(bottom: 50),
      height: height*0.75,width: width,
      child: RefreshIndicator(
        onRefresh: _refreshposts,
        
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: postlist.length,
          itemBuilder: (context,index){
            DocumentSnapshot poste = postlist[index];
            final post = poste.data() as Map<String, dynamic>;
            return Column(
            children : [
            posts(height, width,post,context),
            SizedBox(height: 13,)
            ]);
          }
          
          ),
      ),
    );
    },
  );
}



Widget posts(double height,double width,Map<String,dynamic> post,BuildContext context){
  return Material(
    elevation: 1,
    color: Colors.white,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: width*0.03),
          width: width,
          child: Column(
            children: [
              SizedBox(height:5),
              postheader(height,width,post,context),
              SizedBox(height: 10,),
              midpart(height,width,post),
              SizedBox(height: 10,),
              bottompart(height,width,post,context)
            ],
          )
        )
      ],
    ),
  );
}

Widget postheader(double height,double width,Map<String,dynamic> post,BuildContext context){
  
  String url = post.containsKey('mypic') ? post['mypic'] : "";
  String name = post.containsKey('name') ? post['name'] : "";
  String posterid = post.containsKey('sender') ? post['sender']:"";
  return Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: posterid)));
        },
        child: Container(
          height: 60,width: 60,
          decoration: BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.hardEdge,
          child:  Image.network(url,fit: BoxFit.cover,),
        ),
      ),
      SizedBox(width: 10,),
      Expanded(child: Text(name,style: TextStyle(fontSize: 16,fontFamily: MyTheme().loginfont),)),
      GestureDetector(
        onTap: () => notAvailable(context),
        child: Icon(Icons.more_vert))
    ],
  );
}

Widget midpart(double height,double width,Map<String,dynamic> post){
  String img = post.containsKey('pic') ? post['pic'] : "";
  String des = post.containsKey('des') ? post['des'] : "Could not load the post properly";
   return Column(
    children: [
      ConstrainedBox(constraints: BoxConstraints(maxHeight: height*0.4,minHeight: 0.2,maxWidth: width*0.9),  
      child: ClipRRect(child: 
      Image.network(img,fit: BoxFit.cover,)
      ),
      ),
      SizedBox(height: 10,),
      
        Container(
          width: width*0.9,
          child: Text(des,
          style: TextStyle(color: Colors.black),
          ))
    ],
  );
}

Widget bottompart(double height,double width,Map<String,dynamic> post,BuildContext context){
  return Container(
    height: height*0.05,width: width*0.9,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 5,),
        likebutton(post: post,),
        SizedBox(width: 3,),
        Nooflikes(post['sender'],post['time']),
          SizedBox(width: width*0.04,),
         Container(
          padding: EdgeInsets.only(top: 2),
           child: InkWell(
            onTap: () {
              commentsspace(context, height, width, post['time'], post['sender']);
            },
            child: SvgPicture.asset("assets/images/comment-2-svgrepo-com.svg",height: 30,width: 30,)
            ),
         ),
         SizedBox(width: width*0.02,),
         Noofcomments(post['sender'],post['time']),
         SizedBox(width: width*0.07,),
         GestureDetector(
          onTap: () => notAvailable(context),
           child: Container(
            padding: EdgeInsets.only(top: 2),
             child: InkWell(
              child: SvgPicture.asset("assets/images/send-email-svgrepo-com.svg",height: 29,width: 29,)
              ),
           ),
         ),
         SizedBox(width: width*0.35,),
         GestureDetector(
          onTap: () => notAvailable(context),
           child: Container(
            padding: EdgeInsets.only(top: 0),
             child: InkWell(
              child: SvgPicture.asset("assets/images/add-square-svgrepo-com.svg",height: 32,width: 32,color: Colors.black,)
              ),
           ),
         )
      ],
    ),
  );
}



class likebutton extends StatefulWidget {
   Map<String,dynamic> post;
     
   likebutton({super.key,required this.post});

  @override
  State<likebutton> createState() => _likebuttonState();
}

class _likebuttonState extends State<likebutton> {
  

  bool isliked = false;
   @override
  void initState() {
    super.initState();

    // Run the like status check AFTER build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkstatus();
    });
  }


  @override
  void changelike(){  
    setState(() {
       isliked = !isliked;
    });
  }

  void checkstatus(){
          final list = context.read<PostProvider>().likedposts;
          for(var doc in list){
            
            if(widget.post['time'] == doc.id){
              
          if(mounted){  setState(() {
            isliked = true;
          });}
          };
          }
  }
  
  @override
  Widget build(BuildContext context) {
    
        
        return Consumer<PostProvider>(
          
          builder: (context, value, child) {
         
           String url = !isliked ? "assets/images/heart-svgrepo-com (1).svg":"assets/images/heart-svgrepo-com.svg";
           Color c = !isliked ? Colors.black : const Color.fromRGBO(250, 23, 27, 1);
           double size = !isliked ? 35 : 35;
         return  GestureDetector(
                onTap: () {
                  
                  if(!isliked){
                    print("liking");
                  context.read<PostProvider>().likepost(widget.post['time'], widget.post['sender']);}
                  else{
                    print("deleting");
                     context.read<PostProvider>().unlikepost(widget.post['time'], widget.post['sender']);
                  }
                  changelike();
                  context.read<PostProvider>().getlikedposts();
                },  
                child: SvgPicture.asset(url,height: size,width: size,color: c,)
                );}
        );
  }
}


Widget Nooflikes(String sender,String postid){
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(sender).collection('posts').doc(postid).collection('likes').snapshots(),
    builder: (context,snapshot){
      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.hasError){
        return Text("");
      }
      else{
        int likes = snapshot.data!.docs.length;
        return Container(
          padding: EdgeInsets.only(top: 5),
          child: Align( alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50),
              child: Text(likes.toString(),style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 17),)))
          );
      }
    }
    );
}
Widget Noofcomments(String sender,String postid){
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(sender).collection('posts').doc(postid).collection('comments').snapshots(),
    builder: (context,snapshot){
      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.hasError){
        return Text("");
      }
      else{
        int comments = snapshot.data!.docs.length;
        return Container(
          padding: EdgeInsets.only(top: 5),
          child: Align( alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50),
              child: Text(comments.toString(),style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 17),)))
          );
      }
    }
    );
}


void commentsspace(BuildContext context,double height,double width,String postid,String senderid){
  TextEditingController mycon = new TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled : true,
    builder: (context){
    
    return Padding(
      
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        
        child: Container(
          height: height*0.9,width: width,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              Text("Comments",style: TextStyle(color: Colors.black,fontFamily: MyTheme().loginfont,fontSize: 18),),
              SizedBox(height: 20,),
              Container(
                height: height*0.7,width: width*0.9,
                child: mycomments(height,width,postid,senderid)
              ),
              Container(
                width: width*0.9,
                child: Row(
                  children: [
                    Container(
                      width: width*0.7,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.only(left: 25),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: height*0.5,minHeight: height*0.05,maxWidth: width*0.7),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: mycon,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a Comment", hintStyle: TextStyle(color: Colors.grey,fontFamily: MyTheme().loginfont)
                          ),
                          style: TextStyle(fontFamily: MyTheme().loginfont),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        context.read<PostProvider>().postReply(mycon.text, senderid, postid);
                        mycon.text = "";
                      },
                      child: Container(
                        height: 50,width: 50,
                        decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.black)),
                        child: Icon(Icons.send,size: 25,),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
   }
   );
}

Widget mycomments(double height,double width,String postid,String senderid){
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(senderid).collection('posts').doc(postid).collection('comments').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: height * 0.035,
                width: width * 0.28,
                child: Center(child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,)),
              );
            } 


      else{
      List<DocumentSnapshot> commentlist = snapshot.data!.docs;
      return Container(
        height: height*0.7,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: commentlist.length,
          itemBuilder: (context,index){
            final comment = commentlist[index];
            return Container(
              width: width*0.9,
              child: Column(
               children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Viewprofile(uid: comment['sender'])));
                      },
                      child: Container(
                        height: 40,width: 40,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.network(comment['profilepic'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(comment['name'], style: TextStyle(fontFamily: MyTheme().loginfont,fontSize: 15,color: Colors.black),),
                  ],
                ),
               // SizedBox(height: 5,),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: width*0.1),
                  child: Text(comment['reply'],style: TextStyle(fontFamily: MyTheme().loginfont,color: const Color.fromRGBO(80, 80, 80, 1)),)),
                  SizedBox(height: height*0.02,)
               ],
              ),
            );
          }),
      );
    }}
  );
}
