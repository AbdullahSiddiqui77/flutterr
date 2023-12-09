import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/roundbutton.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {
 final postController= TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('user');//firestore mn humey khud collection banane hoti hY
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Add FireStore data")),),
    
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
 //opper humnay collection banaye jese firebase data base mn reference banatey the ismay collection banaenge ab idhar documnet banaenge us collection ka
 String id = DateTime.now().millisecondsSinceEpoch.toString();//ab humare database mn jo id hogi woh same hogi different nh hogi ye update krte time easy rehta hay
 fireStore.doc(id).set({
'title':postController.text.toString(),
'id': id,
 }).then((value){
  setState(() {
    loading=false;
  });
Utils().toastMessage('post Added');
 }).onError((error, stackTrace){
  setState(() {
    loading = false;
  });
  Utils().toastMessage(error.toString());
 });         
          
        })
      ],),
    ),);

  }
  
}