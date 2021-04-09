import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/loaded.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text('Signout'),
        onPressed: () {
          auth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Loaded(),
            ),
          );
        },
      ),
    ));
  }
}
