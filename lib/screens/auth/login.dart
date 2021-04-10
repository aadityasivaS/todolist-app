import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todolist/components/errorAlert.dart';
import 'package:todolist/components/input.dart';
import 'package:todolist/screens/app/app.dart';
import 'package:todolist/screens/auth/register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Divider(
                  height: 17,
                  thickness: 1.5,
                ),
                Input(
                  label: 'Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                Input(
                  label: 'Password',
                  controller: passwordController,
                  obscure: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text == '') {
                            showErrorDialog(
                              context,
                              'Error',
                              'Please provide an email address',
                            );
                          } else if (passwordController.text == '') {
                            showErrorDialog(
                              context,
                              'Error',
                              'Please provide a password',
                            );
                          } else if (EmailValidator.validate(
                                  emailController.text) ==
                              false) {
                            showErrorDialog(context, 'Error', 'Invalid email');
                          } else {
                            EasyLoading.show(status: 'Please wait...');
                            try {
                              EasyLoading.dismiss();
                              auth
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppScreen(),
                                  ),
                                );
                              });
                            } on FirebaseAuthException catch (e) {
                              EasyLoading.dismiss();
                              if (e.code == 'user-not-found') {
                                showErrorDialog(
                                  context,
                                  'Error',
                                  'Email or password is incorrect',
                                );
                              } else if (e.code == 'wrong-password') {
                                showErrorDialog(
                                  context,
                                  'Error',
                                  'Email or password is incorrect',
                                );
                              }
                            } catch (e) {
                              showErrorDialog(context, 'Error', e.toString());
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Text('Login'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Text('Don\'t have an account? Create one!'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
