
import 'dart:async';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/auth/loginscreen.dart';
import 'package:firebase_tutorial/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_tutorial/ui/posts/postscreen.dart';
import 'package:flutter/material.dart';
class SplashServices{
  void isLogin(BuildContext context){
    final auth= FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user !=null){
      Timer(Duration(seconds: 3), () {
    
   Navigator.push(context,MaterialPageRoute(builder: (context)=>PostScreen()));
   });
    }else{
  Timer(Duration(seconds: 3), () {
    
   Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
   });
  }}
}