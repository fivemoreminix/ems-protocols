import 'package:flutter/material.dart';

class BookmarksPage extends StatelessWidget {
  BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Bookmarks")),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => ListTile(
                  title: Text("Item $index"),
                  subtitle:
                      Text("Section 1 -> Subsection 1.2 -> Airway Management"),
                )));
  }
}
