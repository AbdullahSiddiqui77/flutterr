import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial/ui/firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../utils/utils.dart';
import '../auth/loginscreen.dart';
import '../posts/add_post.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;

  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("FireStore")),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout)),
          SizedBox(
            width: 13,
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 15,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              if (snapshot.hasError) return Text("Some Error");

              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                           onTap: () {
                          //   ref
                          //       .doc(
                          //           snapshot.data!.docs[index]['id'].toString())
                          //       .update({
                          //     'title': 'I m not good in flutter'   //ye purey on tap wale function per ye hoga jese subscibe wala button click krte hay toh subscribed hojata hay usi taraha ismay hoga sab say phele opper override mn collection reference say reference denge user ki phir ye on tap wala function apply hoga
                          //   }).then((value) {
                          //     Utils().toastMessage('updated');
                          //   }).onError((error, stackTrace) {
                          //     Utils().toastMessage(error.toString());
                            //});
                            ref.doc(snapshot.data!.docs[index]['id'].toString()).delete(); //sirf is statment sy delete hojayega remove hum firebase database mn krte hay idhar firestore mn hum delete krenge
                          },
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                        );
                      }));
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFireStoreData()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: "Edit here!"),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Update"))
            ],
          );
        });
  }
}
