import 'package:flutter/material.dart';
import 'package:todolist_app/screens/app/app.dart';
import 'package:todolist_app/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_app/screens/auth/verify.dart';
class Loaded extends StatefulWidget {
  @override
  _LoadedState createState() => _LoadedState();
}

class _LoadedState extends State<Loaded> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return auth.currentUser == null ? Login() : auth.currentUser!.emailVerified ? AppScreen() : Verify();
  }
}