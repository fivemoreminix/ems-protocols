import 'package:ems_protocols/home.dart';
import 'package:ems_protocols/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
  ]);

  runApp(const MyApp());
}

class UserData {
  UserData({required this.bookmarkedEntryNames});

  List<String> bookmarkedEntryNames;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserData? userAccount;

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

    // userAccount = Account(
    //     email: 'thelukaswils@gmail.com',
    //     name: 'Luke',
    //     bookmarkedEntryNames: []);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMS Protocols',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      routes: {
        '/': (context) {
          return const AuthGate();
        },
      },
    );
  }
}
