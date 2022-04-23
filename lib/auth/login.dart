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
          return const SigninPage(); // Welcome page will lead to the sign in page.
        }

        // User must be signed into Firebase by now, to have UserData
        return RootPage(userAccount: UserData(FirebaseAuth.instance.currentUser!));
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
  bool showAdminForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: GenericSignin(
          // I use this generic sign in form to present one for admin accounts
          // and another for users.
          onSwitchForms: () {
            setState(() => showAdminForm = !showAdminForm);
          },
          subtitleText: showAdminForm ? 'For admins and owners' : 'For users',
          switchFormsText:
              showAdminForm ? 'Go to user login' : 'Go to owner login',
          userFieldType:
              showAdminForm ? _UserFieldType.email : _UserFieldType.username,
        ));
  }
}

enum _UserFieldType {
  email,
  username,
}

class GenericSignin extends StatefulWidget {
  const GenericSignin(
      {Key? key,
      required this.onSwitchForms,
      required this.subtitleText,
      required this.switchFormsText,
      required this.userFieldType})
      : super(key: key);

  final Function() onSwitchForms;
  final String subtitleText;
  final String switchFormsText;
  final _UserFieldType userFieldType;

  @override
  State<GenericSignin> createState() => _GenericSigninState();
}

class _GenericSigninState extends State<GenericSignin> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String? errorMessage;
  bool loading = false;

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
                          widget.subtitleText,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        TextButton(
                          child: Text(widget.switchFormsText),
                          onPressed: widget.onSwitchForms,
                        ),
                      ],
                    )
                  ]),
                  TextFormField(
                      controller: userController,
                      decoration: InputDecoration(
                          hintText:
                              (widget.userFieldType == _UserFieldType.email)
                                  ? 'email address'
                                  : 'username')),
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
                      try {
                        var user = userController.text.trim();
                        if (widget.userFieldType == _UserFieldType.username) {
                          user +=
                              usernameEmailSuffix; // Some arbitrary but constant domain for managed accounts
                        }
                        final pass = passController.text;

                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: user, password: pass);
                      } catch (e) {
                        final exc = e as FirebaseAuthException;
                        switch (exc.code) {
                          case 'invalid-email':
                            errorMessage =
                                (widget.userFieldType == _UserFieldType.email)
                                    ? "Invalid email address"
                                    : "Invalid username";
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
