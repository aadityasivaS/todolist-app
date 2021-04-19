import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';
import 'package:todolist/screens/app/listView.dart';

class StarredTab extends StatefulWidget {
  @override
  _StarredTabState createState() => _StarredTabState();
}

class _StarredTabState extends State<StarredTab> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference starredLists = FirebaseFirestore.instance
        .collection('users/${auth.currentUser!.uid}/starred');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Your Starred Lists',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: starredLists.snapshots(),
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
                        'You currently have no starred lists',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.data != null) {
                  EasyLoading.dismiss();
                  snapshot.data!.docs.forEach((doc) {
                    precacheImage(NetworkImage(doc.get('imageURL')), context);
                  });
                  return Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        initialPage: 0,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 0.84,
                      ),
                      items: snapshot.data!.docs.map(
                        (doc) {
                          return OpenContainer(
                            closedBuilder: (context, action) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 4.0),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      doc.get('imageURL'),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Hero(
                                    tag: 'titleCard',
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.6),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          doc.get('title'),
                                          style: TextStyle(
                                            fontSize: 35.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            openBuilder: (context, action) => ListViewScreen(
                              bgImageURL: doc.get('imageURL'),
                              title: doc.get('title'),
                              docID: doc.id,
                              uid: auth.currentUser!.uid,
                              starred: true,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
