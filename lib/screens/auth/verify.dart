import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist_app/components/errorAlert.dart';
import 'package:todolist_app/screens/auth/login.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/email-animation.zip',
                  repeat: false, width: 350),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Text(
                  'We have sent you a verification email please click on the link in the email to verify your account after you verify your email press login below',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: Text('Login'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  EasyLoading.show(status: 'Sending');
                  auth.currentUser!.sendEmailVerification().then((value) {
                    EasyLoading.dismiss();
                    EasyLoading.showToast('Sent');
                  }).onError((error, stackTrace) {
                    showErrorDialog(context, 'Error', error.toString());
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: Text('Resend'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
