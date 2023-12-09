import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:firebase_tutorial/widgets/roundbutton.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController= TextEditingController();
  bool loading = false;
  final databaseRef= FirebaseDatabase.instance.ref('Post');  //post humnay table banane kay liye use kra hay hum issay firebase mn node kehte hay
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Post"),),
    
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        SizedBox(height: 30,),
        TextFormField(
          controller: postController,
          maxLines: 4,
          decoration: InputDecoration(hintText: "what's in your mind",
          border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 30,),
        Roundbutton(title: 'Add',
        loading: loading,
         onTap: (){
          setState(() {
            loading=true;
          });
          String id = DateTime.now().millisecondsSinceEpoch.toString();
          databaseRef.child(id).set({
            'id' : id,
          'title' : postController.text.toString() 
          }).then((value){
             Utils().toastMessage("Post Added");
            setState(() {
              loading=false;
            });
             
          }).onError((error, stackTrace){
            Utils().toastMessage(error.toString());
            setState(() {
              loading= false;
            });
          });
        })
      ],),
    ),);

  }
  
}