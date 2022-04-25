import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userController = TextEditingController();
  var pass1Controller = TextEditingController();
  var pass2Controller = TextEditingController();
  String? errorMessage;
  bool passwordsMatch = false;
  bool showPasswordsMatch = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Account')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: userController,
                    decoration:
                        const InputDecoration(hintText: 'email address'),
                  ),
                  passwordFormField(
                    context,
                    controller: pass1Controller,
                    hintText: 'password',
                  ),
                  passwordFormField(context,
                      controller: pass2Controller,
                      hintText: 'confirm password', onChanged: (value) {
                    setState(() {
                      showPasswordsMatch = true;
                      passwordsMatch = value == pass1Controller.text;
                    });
                  }),
                  const SizedBox(height: 8),
                  if (showPasswordsMatch)
                    Text(
                      passwordsMatch
                          ? 'Passwords match'
                          : 'Passwords do not match',
                      style: TextStyle(
                          color: passwordsMatch ? Colors.green : Colors.black),
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      child: const Text('Register'),
                      onPressed: passwordsMatch
                          ? () async {
                              final user = userController.text.trim();
                              final pass = pass1Controller.text;

                              setState(() {
                                loading = true;
                              });
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: user, password: pass);
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: user, password: pass);
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'email-already-in-use':
                                    errorMessage =
                                        'That email is already in use.';
                                    break;
                                  case 'invalid-email':
                                    errorMessage =
                                        'An invalid email address is provided.';
                                    break;
                                  case 'operation-not-allowed':
                                    errorMessage = 'Operation not allowed.';
                                    break;
                                  case 'weak-password':
                                    errorMessage = 'That password is too weak.';
                                    break;
                                }
                              }
                              setState(() {
                                errorMessage;
                                loading = false;
                              });
                              Navigator.pop(context);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  const SizedBox(height: 32),
                  Text(
                    'TODO: terms of service, privacy policy',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
