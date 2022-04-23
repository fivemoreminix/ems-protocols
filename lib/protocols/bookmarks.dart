import 'package:ems_protocols/protocols/protocols_menu.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BookmarksPage extends StatefulWidget {
  BookmarksPage({Key? key, required this.collection, required this.userData})
      : super(key: key);

  final ProtocolCollection collection;
  final UserData userData;

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    updateBookmarks();
  }

  void updateBookmarks() async {
    bookmarks = await widget.userData.getBookmarks();
    setState(() => bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Bookmarks")),
        body: ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              var bookmarkTitle = bookmarks[index];
              var item = widget.collection.getItemByTitle(bookmarkTitle);

              // TODO: if item is null, remove entry from account
              if (item != null) {
                // TODO: replace this with buildProtocolEntryListItem.
                return ListTile(
                  title: Text(item.title),
                  onTap:
                      () {}, // TODO: handle tapping bookmark items (fixed by above)
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
