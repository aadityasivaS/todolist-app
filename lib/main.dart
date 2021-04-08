import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/screens/loaded.dart';
import 'package:todolist/screens/loading.dart';
import 'package:todolist/screens/error.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Color(0xFF6366F1);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        textTheme: GoogleFonts.interTextTheme(textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            textStyle: TextStyle(fontSize: 23),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: primaryColor,
          ),
        ),
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Error();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Loaded();
          }
          return Loading();
        },
      ),
    );
  }
}
