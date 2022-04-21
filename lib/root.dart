import 'package:ems_protocols/main.dart';
import 'package:flutter/material.dart';

import 'bookmarks.dart';
import 'settings.dart';
import 'protocols_menu.dart';

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

  ProtocolCollection protocol = ProtocolCollection(title: '', items: []);

  @override
  void initState() {
    super.initState();

    loadProtocols().then((value) {
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
            userAccount: widget.userAccount,
            collection: protocol,
            searchable: true),
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
