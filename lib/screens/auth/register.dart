import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/components/input.dart';
import 'package:email_validator/email_validator.dart';
import 'package:todolist/components/errorAlert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todolist/screens/loaded.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _currentStep = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void register(context, email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        EasyLoading.dismiss();
        value.user!.sendEmailVerification().then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Loaded()),
          );
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorDialog(context, 'Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog(
            context, 'Error', 'The account already exists for that email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Divider(
                  height: 17,
                  thickness: 1.5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Have an account? Login Instead'),
                ),
                Container(
                  height: 400,
                  width: 400,
                  child: Stepper(
                    currentStep: _currentStep,
                    controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed: onStepContinue,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                child: const Text('Next'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    onStepCancel: () {
                      if (_currentStep <= 0) {
                        return;
                      }
                      setState(() {
                        _currentStep--;
                      });
                    },
                    onStepContinue: () {
                      if (_currentStep >= 2) {
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
                          register(context, emailController.text,
                              passwordController.text);
                          EasyLoading.show(status: 'Please wait...');
                        }
                        return;
                      }
                      setState(() {
                        if (_currentStep == 0) {
                          if (EmailValidator.validate(emailController.text)) {
                            _currentStep++;
                          } else {
                            showErrorDialog(context, 'Error', 'Invalid email');
                          }
                        } else {
                          _currentStep++;
                        }
                      });
                    },
                    onStepTapped: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    steps: [
                      Step(
                        title: Text(
                          "Enter your Email",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        isActive: _currentStep == 0,
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Input(
                                label: 'Email',
                                controller: emailController,
                                inputType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: Text(
                          "Set a password",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        isActive: _currentStep == 1,
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Input(
                                label: 'Password',
                                controller: passwordController,
                                obscure: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: Text(
                          "Verify your email",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        isActive: _currentStep == 2,
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'When you press the next button we will send you a verification email.',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
