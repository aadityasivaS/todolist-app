import 'package:flutter/material.dart';
import 'package:todolist/screens/auth/login.dart';
import 'package:todolist/screens/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Loaded extends StatefulWidget {
  @override
  _LoadedState createState() => _LoadedState();
}

class _LoadedState extends State<Loaded> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return auth.currentUser == null ? Login() : Loading();
  }
}