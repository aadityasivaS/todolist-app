import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todolist/components/errorAlert.dart';
import 'package:todolist/components/input.dart';

class ListViewScreen extends StatefulWidget {
  final String bgImageURL;
  final String title;
  final String docID;
  final String uid;
  final bool starred;
  const ListViewScreen(
      {required this.bgImageURL,
      required this.title,
      required this.docID,
      required this.uid,
      required this.starred});
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController modalNewTask = TextEditingController();
  bool starred = false;
  @override
  void initState() {
    if (widget.starred) {
      starred = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance
        .collection('users/${widget.uid}/lists/${widget.docID}/tasks');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: NetworkImage(widget.bgImageURL),
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 18.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'titleCard',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              PopupMenuButton(
                                onSelected: (clicked) {
                                  if (clicked == 'Delete') {
                                    EasyLoading.show(status: 'Please wait...');
                                    db
                                        .doc(
                                          'users/${widget.uid}/lists/${widget.docID}',
                                        )
                                        .delete()
                                        .then((value) {
                                      EasyLoading.dismiss();
                                      Navigator.pop(context);
                                    });
                                  } else if (clicked == 'Star') {
                                    setState(() {
                                      starred = !starred;
                                      if (starred == true) {
                                        db
                                            .doc(
                                                'users/${widget.uid}/starred/${widget.docID}')
                                            .get()
                                            .then((doc) {
                                          if (!doc.exists) {
                                            db
                                                .collection(
                                                    'users/${widget.uid}/starred')
                                                .doc(widget.docID)
                                                .set({
                                              'title': widget.title,
                                              'imageURL': widget.bgImageURL
                                            });
                                          }
                                        });
                                      } else {
                                        db
                                            .doc(
                                                'users/${widget.uid}/starred/${widget.docID}')
                                            .delete();
                                      }
                                      db
                                          .doc(
                                              'users/${widget.uid}/lists/${widget.docID}')
                                          .update({'starred': starred});
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: 'Delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text('Delete')
                                      ],
                                    ),
                                  ),
                                  PopupMenuDivider(),
                                  PopupMenuItem(
                                    value: 'Star',
                                    child: Row(
                                      children: [
                                        Icon(
                                          !starred
                                              ? Icons.star
                                              : Icons.star_border,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          !starred ? 'Star' : 'Unstar',
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: tasks.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                'Something went wrong',
                                style: TextStyle(color: Colors.white),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              EasyLoading.show(status: 'Loading...');
                            }

                            if (snapshot.data != null &&
                                snapshot.data!.docs.length == 0) {
                              EasyLoading.dismiss();
                              return Flexible(
                                child: Center(
                                  child: Text(
                                    'You currently have no tasks press the + button to make one',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return snapshot.data != null
                                ? Flexible(
                                    child: ListView(
                                        children:
                                            snapshot.data!.docs.map((doc) {
                                      EasyLoading.dismiss();
                                      return ListTile(
                                        title: Text(
                                          doc.data()['title'],
                                          style: TextStyle(
                                            decoration: doc.data()['done']
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            color: Colors.white,
                                          ),
                                        ),
                                        trailing: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor: Colors.white,
                                          ),
                                          child: Checkbox(
                                            value: doc.data()['done'],
                                            onChanged: (newValue) {
                                              tasks.doc(doc.id).update(
                                                {'done': !doc.data()['done']},
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : Container();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
                      vertical: 60,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'New Task',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Input(
                          label: 'Title',
                          controller: modalNewTask,
                          center: true,
                          suggestions: true,
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (modalNewTask.text != '') {
                              EasyLoading.show(status: 'Please wait...');
                              tasks.add({
                                'title': modalNewTask.text,
                                'done': false
                              }).then((value) {
                                modalNewTask.text = '';
                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                              });
                            } else {
                              EasyLoading.dismiss();
                              showErrorDialog(
                                context,
                                'Error',
                                'Please provide a task title',
                              );
                            }
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add Task'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        heroTag: 'SharedFAB',
      ),
    );
  }
}
