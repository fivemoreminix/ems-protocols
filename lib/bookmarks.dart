import 'package:ems_protocols/protocols_menu.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class BookmarksPage extends StatelessWidget {
  BookmarksPage({Key? key, required this.collection, required this.userAccount})
      : super(key: key);

  final ProtocolCollection collection;
  final UserData userAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Bookmarks")),
        body: ListView.builder(
            itemCount: userAccount.bookmarkedEntryNames.length,
            itemBuilder: (context, index) {
              var bookmarkTitle = userAccount.bookmarkedEntryNames[index];
              var item = collection.getItemByTitle(bookmarkTitle);
              // TODO: if item is null, remove entry from account
              if (item != null) {
                return ListTile(
                  title: Text(item.title),
                  onTap: () {}, // TODO: handle tapping bookmark items
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark_remove),
                    onPressed: () {},
                  ),
                );
              } else {
                return Text('Null entry $bookmarkTitle');
              }
            }));
  }
}
