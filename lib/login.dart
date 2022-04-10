import 'package:ems_protocols/root.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {}

        return RootPage(
            userAccount:
                Account(email: '', name: '', bookmarkedEntryNames: []));
      },
    );
  }
}

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('User sign in'),
        TextFormField(),
        TextFormField(),
        Center(
            child: TextButton(
          child: const Text('Sign in'),
          onPressed: () {},
        )),
      ],
    );
  }
}
