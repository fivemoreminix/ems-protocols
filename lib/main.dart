import 'package:ems_protocols/home.dart';
import 'package:ems_protocols/login.dart';
import 'package:ems_protocols/root.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Account {
  Account(
      {required this.email,
      required this.name,
      required this.bookmarkedEntryNames});

  String email;
  String name;
  List<String> bookmarkedEntryNames;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Account? userAccount;

  @override
  void initState() {
    super.initState();

    // TODO: read from local database or settings about account info
    // TODO: connect to firebase and auth with existing credentials
    // TODO: send user to login page without credentials

    // If user has an account, send them to RootPage or (/home)
    // If user does not have an account, send them to HomePage or (/) to explain product
    //   and offer the user to log into an existing account or offer options for
    //   companies.

    userAccount = Account(
        email: 'thelukaswils@gmail.com',
        name: 'Luke',
        bookmarkedEntryNames: []);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMS Protocols',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routes: {
        '/': (context) {
          if (userAccount == null) {
            // TODO: or otherwise not able to auth
            return const HomePage();
          } else {
            return RootPage(userAccount: userAccount!);
          }
        },
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
