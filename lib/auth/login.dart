import 'package:ems_protocols/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

/// AuthGate checks if a user is signed into Firebase before allowing them to
/// access content in the app. A user not signed in will be directed to a sign-in
/// page.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginPage(); // Welcome page will lead to the sign in page.
        }

        // User must be signed into Firebase by now, to have UserData
        return RootPage(
            userAccount: UserData(FirebaseAuth.instance.currentUser!));
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String? errorMessage;
  bool loading = false;

  final emailRegexp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool isEmail(String text) {
    return emailRegexp.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text('EMS Protocols',
                          style: Theme.of(context).textTheme.headline2)),
                  const SizedBox(height: 32.0),
                  Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextFormField(
                      controller: userController,
                      decoration:
                          const InputDecoration(hintText: 'username or email')),
                  TextFormField(
                    controller: passController,
                    decoration: const InputDecoration(hintText: 'password'),
                    obscureText: true,
                  ),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  const SizedBox(height: 8.0),
                  Center(
                      child: ElevatedButton(
                    child: const Text('Sign in'),
                    onPressed: () async {
                      setState(() => loading = true);

                      String user = userController.text.trim();
                      if (!isEmail(user)) {
                        user +=
                            usernameEmailSuffix; // Make the username a fake email
                      }
                      final pass = passController.text;

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: user, password: pass);
                      } catch (e) {
                        final exc = e as FirebaseAuthException;
                        switch (exc.code) {
                          case 'invalid-email':
                            errorMessage = 'Invalid username or email address.';
                            break;
                          case 'user-disabled':
                            errorMessage =
                                "Unable to login: your account was disabled.";
                            break;
                          case 'user-not-found':
                            errorMessage = "The account with that username or email could not be found.";
                            break;
                          case 'wrong-password':
                            errorMessage =
                                "That password is not correct for your account.";
                            break;
                          default:
                            throw ErrorDescription(
                                'Unhandled FirebaseAuthException code');
                        }
                        setState(() => loading = false);
                      }
                    },
                  )),
                  TextButton(
                    child: const Text('Create an account'),
                    onPressed: () {}, // TODO: create an account handler
                  )
                ],
              ))),
      if (loading) const Center(child: CircularProgressIndicator()),
    ]));
  }
}
