import 'package:ems_protocols/root.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SigninPage();
        }

        return RootPage(userAccount: UserData(bookmarkedEntryNames: []));
      },
    );
  }
}

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String? errorMessage;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text('EMS Protocols',
                      style: Theme.of(context).textTheme.headline2)),
              const SizedBox(height: 32.0),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'For employees',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextButton(
                      child: const Text('Go to owner login'),
                      onPressed: () {},
                    ),
                  ],
                )
              ]),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'email address')),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(hintText: 'password'),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red),
                ),
              Center(
                  child: TextButton(
                child: const Text('Sign in'),
                onPressed: () async {
                  try {
                    setState(() => loading = true);
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text);
                  } catch (e) {
                    final exc = e as FirebaseAuthException;
                    switch (exc.code) {
                      case 'invalid-email':
                        errorMessage = "Invalid email address";
                        break;
                      case 'user-disabled':
                        errorMessage = "Your account has been disabled";
                        break;
                      case 'user-not-found':
                        errorMessage = "Your account cannot be found.";
                        break;
                      case 'wrong-password':
                        errorMessage =
                            "That password is not correct for your account.";
                        break;
                      default:
                        throw ErrorDescription(
                            'Unexpected FirebaseAuthException code');
                    }
                    setState(() => loading = false);
                  }
                },
              )),
            ],
          )),
      if (loading) const Center(child: CircularProgressIndicator()),
    ]));
  }
}
