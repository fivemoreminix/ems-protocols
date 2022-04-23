import 'dart:convert';

import 'package:ems_protocols/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

import 'pdf_viewer.dart';

/// A ProtocolEntry is the base class for ProtocolCollection and ProtocolItem
/// for OOP to represent the protocols in code.
class ProtocolEntry {
  ProtocolEntry(this.title, this.path);

  String title;
  String path;
}

class ProtocolCollection extends ProtocolEntry {
  ProtocolCollection(String title, String path, this.items)
      : super(title, path);

  List<ProtocolEntry> items;

  /// walkItems runs the provided func against every ProtocolItem in the collection,
  /// and every subcollection. walkItems exits when all items have been visited
  /// or func returns true.
  void walkItems(bool Function(ProtocolItem) func) {
    for (var entry in items) {
      if (entry is ProtocolItem) {
        if (func(entry)) return;
      } else if (entry is ProtocolCollection) {
        entry.walkItems(func);
      }
    }
  }

  /// getItemByTitle visits every item in the collection and subcollections
  /// recursively until the first item with the same title is found, otherwise
  /// a null item is returned.
  ProtocolItem? getItemByTitle(String title) {
    ProtocolItem? found;
    walkItems((item) {
      if (item.title == title) {
        found = item;
        return true;
      }
      return false;
    });
    return found;
  }
}

/// A ProtocolItem is to a ProtocolCollection as a leaf is to a tree. These
/// ProtocolItems contain a file path to a document or image in the assets.
class ProtocolItem extends ProtocolEntry {
  ProtocolItem(String title, String path) : super(title, path);
}

/// parseProtocolCollectionJson reads a tree of JSON and compiles it into a
/// ProtocolCollection of ProtocolItems and sub-ProtocolCollections.
ProtocolCollection? parseProtocolCollectionJson(
    Map<String, dynamic> json, String collectionPath) {
  var collection = ProtocolCollection('Protocols', collectionPath, []);
  for (var entry in json.entries) {
    if (entry.value is Map) {
      var c = parseProtocolCollectionJson(entry.value, collectionPath);
      if (c == null) {
        throw ErrorDescription('Protocol collection is empty');
      }
      c.title = entry.key;
      collection.items.add(c);
    } else if (entry.value is String) {
      collection.items.add(ProtocolItem(
          entry.key,
          // Make all values relative to the folder containing protocols.json
          collectionPath + "/" + entry.value));
    } else {
      throw ErrorDescription(
          'Value of type ${entry.value.runtimeType} in Protocol JSON is not a Map or String');
    }
  }
  return collection;
}

/// loadProtocols is a helper function to load the given protocol, decode it,
/// and then build a ProtocolCollection from it, which is returned as a Future.
///
/// Example: loadProtocols("assets/Northwest AR Regional Protocols 2018")
Future<ProtocolCollection?> loadProtocol(String protocol) async {
  var json = await rootBundle.loadString(protocol + '/protocols.json');
  return parseProtocolCollectionJson(jsonDecode(json), protocol);
}

/// buildProtocolEntryListItem is a helper function for building the items in
/// protocol entry lists, where there is a protocol entry name and a bookmark
/// button.
Widget buildProtocolEntryListItem(BuildContext context,
    {required ProtocolEntry item,
    required List<String> bookmarkedEntryNames,
    void Function()? onTap,
    bool? showBookmarkButton,
    required void Function(void Function()) setState}) {
  return ListTile(
      title: Text(item.title),
      onTap: onTap,
      trailing: () {
        bool bookmarked = bookmarkedEntryNames.contains(item.title);
        return (item is ProtocolItem)
            ? IconButton(
                icon: Icon(bookmarked
                    ? Icons.bookmark_added
                    : Icons.bookmark_add_outlined),
                onPressed: () {
                  if (bookmarked) {
                    setState(() {
                      bookmarkedEntryNames.remove(item.title);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${item.title} has been removed from your bookmarks.')));
                  } else {
                    setState(() => bookmarkedEntryNames.add(item.title));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${item.title} has been added to your bookmarks.')));
                  }
                },
              )
            : null;
      }());
}

class ProtocolsMenu extends StatefulWidget {
  ProtocolsMenu(this.collection,
      {Key? key,
      this.rootCollection,
      required this.userAccount,
      required this.searchable})
      : super(key: key);

  final ProtocolCollection collection;
  final ProtocolCollection? rootCollection;
  bool searchable = false;
  final UserData userAccount;

  @override
  State<ProtocolsMenu> createState() => _ProtocolsMenuState();
}

class _ProtocolsMenuState extends State<ProtocolsMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.collection.title),
          actions: widget.searchable // Search page feature
              ? [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProtocolsSearchPage(
                                  searchableCollection: widget.collection,
                                  userAccount: widget.userAccount)));
                    },
                  )
                ]
              : null,
        ),
        body: ListView.builder(
            itemCount: widget.collection.items.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.collection.items[index];

              return buildProtocolEntryListItem(context,
                  item: item,
                  bookmarkedEntryNames: widget.userAccount.bookmarkedEntryNames,
                  setState: setState, onTap: () {
                if (item is ProtocolCollection) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProtocolsMenu(item,
                              rootCollection: widget.collection,
                              userAccount: widget.userAccount,
                              searchable: false)));
                } else if (item is ProtocolItem) {
                  print('Opening ${item.path} in PDF viewer');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProtocolPdfPage(
                            PdfControllerPinch(
                                document: PdfDocument.openAsset(item.path)))),
                  );
                } else {
                  throw ErrorDescription(
                      'item must be either ProtocolCollection or ProtocolItem, is ${item.runtimeType} instead');
                }
              });
            }));
  }
}

/// The ProtocolsSearchPage is a fullscreen page for searching protocols by name.
class ProtocolsSearchPage extends StatefulWidget {
  const ProtocolsSearchPage(
      {Key? key, required this.searchableCollection, required this.userAccount})
      : super(key: key);

  final ProtocolCollection searchableCollection;
  final UserData userAccount;

  @override
  State<ProtocolsSearchPage> createState() => _ProtocolsSearchPageState();
}

class _ProtocolsSearchPageState extends State<ProtocolsSearchPage> {
  final controller = TextEditingController();
  List<ProtocolItem> matches = [];

  void updateMatches(String text) {
    matches.clear();
    if (text.isEmpty) return;
    var textLowercase = text.toLowerCase();
    widget.searchableCollection.walkItems((item) {
      if (item.title.toLowerCase().contains(textLowercase)) {
        matches.add(item);
      }
      return false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: Theme.of(context).secondaryHeaderColor)
        .titleLarge;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: controller,
          style: searchTheme,
          decoration: InputDecoration(
            hintText: 'Search protocols',
            hintStyle: searchTheme?.copyWith(color: Colors.grey),
          ),
          showCursor: true,
          cursorColor: searchTheme?.color,
          onChanged: (contents) {
            setState(() => updateMatches(contents));
          },
        ),
      ),
      body: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) => buildProtocolEntryListItem(
                context,
                item: matches[index],
                bookmarkedEntryNames: widget.userAccount.bookmarkedEntryNames,
                setState: setState,
                onTap: () {},
              )),
    );
  }
}
