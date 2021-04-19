import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todolist/components/errorAlert.dart';
import 'package:todolist/components/input.dart';
import 'package:todolist/screens/app/tabs/lists.dart';
import 'package:todolist/screens/app/tabs/account.dart';
import 'package:todolist/screens/app/tabs/starred.dart';
import 'package:http/http.dart' as http;

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController modalNewList = TextEditingController();
  int currentPage = 0;
  List<Widget> tabs = [ListsTab(), StarredTab(), AccountSettings()];
  @override
  void initState() {
    String uid = auth.currentUser!.uid;
    addUserDocIfNotExists(uid);
    super.initState();
  }

  Future<String?> getImage(title) async {
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://pixabay.com/api/?key=${env['PIXABAY_API_KEY']}&q=$title&per_page=3',
      ),
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      return jsonDecode(res)['hits'][0]['largeImageURL'];
    } else {
      showErrorDialog(context, 'Error', response.reasonPhrase);
    }
  }

  void addUserDocIfNotExists(uid) async {
    await db.doc('users/$uid').get().then((doc) {
      if (!doc.exists) {
        db.collection('users').doc(auth.currentUser!.uid).set({});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid;
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
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: currentPage == 0,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          heroTag: 'SharedFAB',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              builder: (context) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60, horizontal: 30),
                      child: Column(
                        children: [
                          Text(
                            'New List',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Input(
                            label: 'Title',
                            controller: modalNewList,
                            center: true,
                            suggestions: true,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (modalNewList.text != '') {
                                EasyLoading.show(status: 'Please wait...');
                                getImage(modalNewList.text).then((value) {
                                  db
                                      .doc('users/$uid')
                                      .collection('lists')
                                      .add({
                                    'title': modalNewList.text,
                                    'imageURL': value.toString(),
                                    'starred': false
                                  }).then((value) {
                                    setState(() {
                                      modalNewList.text = '';
                                      EasyLoading.dismiss();
                                      Navigator.of(context).pop();
                                    });
                                  });
                                });
                              } else {
                                EasyLoading.dismiss();
                                showErrorDialog(
                                  context,
                                  'Error',
                                  'Please provide a list title',
                                );
                              }
                            },
                            icon: Icon(Icons.add),
                            label: Text('Add List'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
