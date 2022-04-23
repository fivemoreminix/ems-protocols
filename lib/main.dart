import 'package:ems_protocols/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';
import 'protocols/bookmarks.dart';
import 'protocols/protocols_menu.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51JXVOWLDqrxoI548GLevEjTDseiKvNagUeAkO4mskctNEYBt25SDin8jytwcQ9Pj0hdjmwqWtorMf4vODlpvL32f00XmXF0Kv2';
  await Stripe.instance.applySettings();

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
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) {
          return const AuthGate();
        },
      },
    );
  }
}

/// The RootPage is the underlying navigator containing the BottomNavigationBar
/// entries for Protocols, Bookmarks, and Settings.
class RootPage extends StatefulWidget {
  RootPage({Key? key, required this.userAccount}) : super(key: key);

  UserData userAccount;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentIndex = 0;

  ProtocolCollection protocol = ProtocolCollection('', '', []);

  @override
  void initState() {
    super.initState();

    loadProtocol('assets/Northwest AR Regional Protocols 2018').then((value) {
      if (value == null) {
        throw ErrorDescription('Protocols is not a ProtocolCollection');
      } else {
        setState(() => protocol = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        ProtocolsMenu(
          protocol,
          userAccount: widget.userAccount,
          searchable: true,
        ),
        BookmarksPage(userAccount: widget.userAccount, collection: protocol),
        SettingsPage(userAccount: widget.userAccount),
      ][currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            label: 'Protocols',
            icon: Icon(Icons.book),
          ),
          BottomNavigationBarItem(
            label: 'Bookmarks',
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
