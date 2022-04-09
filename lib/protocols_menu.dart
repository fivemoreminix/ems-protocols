import 'dart:convert';

import 'package:ems_protocols/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProtocolEntry {
  ProtocolEntry(this.title);

  String title;
}

class ProtocolCollection extends ProtocolEntry {
  ProtocolCollection({required String title, required this.items})
      : super(title);

  List<ProtocolEntry> items;

  void walkItems(bool Function(ProtocolItem) func) {
    for (var entry in items) {
      if (entry is ProtocolItem) {
        if (func(entry)) return;
      } else if (entry is ProtocolCollection) {
        entry.walkItems(func);
      }
    }
  }

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

class ProtocolItem extends ProtocolEntry {
  ProtocolItem({required String title, this.documentUri}) : super(title);

  Uri? documentUri;
}

ProtocolCollection? parseProtocolCollectionJson(Map<String, dynamic> json) {
  var collection = ProtocolCollection(title: 'Protocols', items: []);
  for (var entry in json.entries) {
    if (entry.value is Map) {
      var c = parseProtocolCollectionJson(entry.value);
      if (c == null) {
        throw ErrorDescription('Protocol collection is empty');
      }
      c.title = entry.key;
      collection.items.add(c);
    } else if (entry.value is String) {
      collection.items.add(
          ProtocolItem(title: entry.key, documentUri: Uri.parse(entry.value)));
    } else {
      throw ErrorDescription(
          'Value of type ${entry.value.runtimeType} in Protocol JSON is not a Map or String');
    }
  }
  return collection;
}

Future<ProtocolCollection?> loadProtocolsJson() async {
  var json = await rootBundle.loadString('assets/protocols.json');
  return parseProtocolCollectionJson(jsonDecode(json));
}

class ProtocolsMenu extends StatefulWidget {
  const ProtocolsMenu(
      {Key? key, required this.collection, required this.userAccount})
      : super(key: key);

  final ProtocolCollection collection;
  final Account userAccount;

  @override
  State<ProtocolsMenu> createState() => _ProtocolsMenuState();
}

class _ProtocolsMenuState extends State<ProtocolsMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.collection.title)),
        body: ListView.builder(
            itemCount: widget.collection.items.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.collection.items[index];
              return ListTile(
                  title: Text(item.title),
                  onTap: () {
                    if (item is ProtocolCollection) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProtocolsMenu(
                                  collection: item,
                                  userAccount: widget.userAccount)));
                    } else if (item is ProtocolItem) {
                      launch(item.documentUri.toString());
                    } else {
                      throw ErrorDescription(
                          'item must be either ProtocolCollection or ProtocolItem, is ${item.runtimeType} instead');
                    }
                  },
                  trailing: () {
                    bool bookmarked = widget.userAccount.bookmarkedEntryNames
                        .contains(item.title);
                    return (item is ProtocolItem)
                        ? IconButton(
                            icon: Icon(bookmarked
                                ? Icons.bookmark_added_outlined
                                : Icons.bookmark_add_outlined),
                            onPressed: () {
                              if (bookmarked) {
                                setState(() {
                                  widget.userAccount.bookmarkedEntryNames
                                      .remove(item.title);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${item.title} has been removed from your bookmarks.')));
                              } else {
                                setState(() => widget
                                    .userAccount.bookmarkedEntryNames
                                    .add(item.title));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${item.title} has been added to your bookmarks.')));
                              }
                            },
                          )
                        : null;
                  }());
            }));
  }
}
