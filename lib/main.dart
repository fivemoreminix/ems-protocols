import 'package:ems_protocols/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
