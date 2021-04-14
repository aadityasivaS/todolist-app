import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/app/tabs/lists.dart';
import 'package:todolist/screens/app/tabs/settings.dart';
import 'package:todolist/screens/app/tabs/starred.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  int currentPage = 0;
  List<Widget> tabs = [ListsTab(), StarredTab(), SettingsTab()];

  @override
  void initState() {
    addUserDocIfNotExists();
    super.initState();
  }

  void addUserDocIfNotExists() async {
    await db.doc('users/${auth.currentUser!.uid}').get().then((doc) {
      if (!doc.exists) {
        db.collection('users').doc(auth.currentUser!.uid).set({});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: tabs[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) => setState(() => currentPage = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Your lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Starred',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: currentPage == 0,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
