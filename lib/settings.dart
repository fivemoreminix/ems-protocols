import 'package:ems_protocols/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

Widget _buildYesNoDialog(BuildContext context, String title, String question) {
  return AlertDialog(
    title: Text(title),
    content: Text(question),
    actions: [
      TextButton(
        child: const Text("No"),
        autofocus: true,
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
      TextButton(
        child: const Text("Yes"),
        onPressed: () {
          Navigator.pop(context, true);
        },
      )
    ],
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.userAccount}) : super(key: key);

  final UserData userAccount;

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (user.photoURL != null)
                      Image(image: NetworkImage(user.photoURL!)),
                    if (user.email != null) Text(user.email!),
                    TextButton(
                      child: const Text('Edit Payment and Billing Info'),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage()));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Sign out"),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () async {
                        var result = await showDialog(
                            context: context,
                            builder: (context) => _buildYesNoDialog(
                                context,
                                "Sign out?",
                                "Are you sure you want to sign out of your account? This will take you back to the login page."));
                        if (result != null && result) {
                          await FirebaseAuth.instance.signOut();
                        }
                      },
                    )
                  ],
                ))));
  }
}
