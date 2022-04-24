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
    if (mounted) {
      setState(() => bookmarks);
    }
  }

  Future<void> removeBookmark(String title) async {
    setState(() => bookmarks.remove(title));
    return widget.userData.setBookmarks(bookmarks);
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

              if (item != null) {
                return buildProtocolEntryListItem(context,
                  setState: setState,
                  item: item,
                  onTap: () => activateProtocolItem(context, item),
                  bookmarked: true,
                  onBookmarked: (BuildContext context) async {
                    // User removed bookmark.
                    await removeBookmark(bookmarkTitle);
                    ScaffoldMessenger.of(context).showSnackBar(snackBarForItemBookmarkChanged(item, added: false));
                  },
                );
              } else {
                () async {
                  await removeBookmark(bookmarkTitle);
                }();
                return Text("Couldn't locate $bookmarkTitle, removed.");
              }
            }));
  }
}
