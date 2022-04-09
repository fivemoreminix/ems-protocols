import 'package:ems_protocols/bookmarks.dart';
import 'package:ems_protocols/profile.dart';
import 'package:ems_protocols/protocols_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMS Protocols',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  ProtocolCollection protocol = ProtocolCollection(title: '', items: []);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    loadProtocolsJson().then((value) {
      if (value == null) {
        throw ErrorDescription('Protocols is not a ProtocolCollection');
      } else {
        setState(() => widget.protocol = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        ProtocolsMenu(collection: widget.protocol),
        BookmarksPage(),
        ProfilePage(),
      ][currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Bookmarks",
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}
