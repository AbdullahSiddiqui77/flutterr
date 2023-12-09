import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/roundbutton.dart';
import '../posts/postscreen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading =
      false; //jab firebase ko call kronga toh frontend per loading show kraonga tb tk
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: verificationCodeController,
            decoration: InputDecoration(hintText: "6 digit code "),
          ),
          SizedBox(
            height: 80,
          ),
         Roundbutton(
              title: "Verify",
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final crendital = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString());
                try {
                  await auth.signInWithCredential(crendital);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
            } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              })
        ]),
      ),
    );
  }
}
