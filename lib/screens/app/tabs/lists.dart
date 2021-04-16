import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ListsTab extends StatefulWidget {
  @override
  _ListsTabState createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usersLists = FirebaseFirestore.instance
        .collection('users/${auth.currentUser!.uid}/lists');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                greeting(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersLists.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading...');
                }

                if (snapshot.data != null && snapshot.data!.docs.length == 0) {
                  EasyLoading.dismiss();
                  return Flexible(
                    child: Center(
                      child: Text(
                        'You currently have no todolists press the + button to make one',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                EasyLoading.dismiss();
                return CarouselSlider(
                  options: CarouselOptions(
                    initialPage: 0,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    height: 500
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Text(
                              'text $i',
                              style: TextStyle(fontSize: 16.0),
                            ));
                      },
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
