import 'package:flutter/material.dart';

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

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Hello, Kelli", style: Theme.of(context).textTheme.headline4),
        TextButton(
          child: const Text("Sign out"),
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.error),
          onPressed: () async {
            var result = showDialog(
                context: context,
                builder: (context) => _buildYesNoDialog(context, "Sign out?",
                    "Are you sure you want to sign out of your account? This will take you back to the login page."));
            switch (await result) {
              case true:
                break;
              case false:
                break;
              default:
                throw ErrorDescription("Result was not boolean");
            }
          },
        )
      ],
    ));
  }
}
