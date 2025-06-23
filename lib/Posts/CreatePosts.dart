import 'package:flutter/material.dart';
import 'package:linkup/Logic/Cloudinary.dart';
import 'package:linkup/Posts/UploadPost.dart';
import 'package:linkup/theme/theme.dart';
import 'package:provider/provider.dart';

class Createposts extends StatefulWidget {
  const Createposts({super.key});

  @override
  State<Createposts> createState() => _CreatepostsState();
}

class _CreatepostsState extends State<Createposts> {
  TextEditingController mycon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        height: height,width: width,
        child: Column(
          children: [
            SizedBox(height: height*0.05,),
            top(height,width,context),
            SizedBox(height: height*0.04,),
            image(height, width),
            SizedBox(height: 10,),
            
            des(height, width, mycon),
            SizedBox(),
            ButtonUpload(des: mycon.text)
            
          ],
        ),
      ),
    );
  }
}



Widget top(double height,double width,BuildContext context){
  return Container(
    height: height*0.06,width: width*0.9,
    child: Row(
      children: [
        InkWell(
          onTap: () { 
          context.read<UploadPost>().reseturl();
          
          Navigator.pop(context);},
          child: Icon(Icons.arrow_back,color: Colors.black,size: 30,)),
        SizedBox(width: 100,),
        Text("ADD POST",style:  TextStyle(color: Colors.black,fontFamily: MyTheme().loginfont,fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    ),
  );
}

Widget image(double height,double width){
  return Selector<UploadPost,String>(
    selector: (p0, p1) => p1.posturl,
    builder: (context,value,child){
     return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height*0.4,minHeight: height*0.2,maxWidth: width*0.9),
      
      child: value == "" ? 
      Container(
        decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(3)),
        height: height*0.3,width: width*0.9,
        child: InkWell(
          onTap: () {
            UploadPostImage(context);
          },
          child: Icon(Icons.add,size: 40,),
        ),
      ):
      
      ClipRRect(
        child: Image.network(value,fit: BoxFit.contain,),
      )
      
     );
  });
}

Widget des(double height,double width,TextEditingController mycon){
  return ConstrainedBox(constraints: BoxConstraints(maxHeight: height*0.3,minHeight: height*0.1,maxWidth: width*0.9),
    child: TextField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: mycon,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Write Something About your Post Here!"
      ),
      style: TextStyle(color: Colors.black,fontFamily: MyTheme().loginfont),
    ),
  );
}

class ButtonUpload extends StatefulWidget {
  String des;
  ButtonUpload({super.key,required this.des});

  @override
  State<ButtonUpload> createState() => _ButtonUploadState();
}

class _ButtonUploadState extends State<ButtonUpload> {
  bool posted = false;

  
  void _UpdateStatus(){
    
    setState(() {
      posted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String text = posted ? "POSTED" : "POST";
    return InkWell(
      onTap: () {
        _UpdateStatus();
        context.read<UploadPost>().Post(widget.des);
      },
      child: Material(
        elevation: posted  ? 0 : 4,
        child: Container(
        height: height*0.055,width: width*0.3,
        decoration: BoxDecoration(color: posted ? Colors.white :  MyTheme().logincolor,borderRadius: BorderRadius.circular(2),border: Border.all(width: posted ? 1:0,color: posted ? Colors.green: Colors.black)),
        child: Center(child: Text(text,style: TextStyle(color: posted ? Colors.green : Colors.white,fontSize: 18,fontFamily: MyTheme().loginfont),)),
        ),
      ),
    );
  }
}