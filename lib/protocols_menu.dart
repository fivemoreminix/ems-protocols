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
                    ? Icons.bookmark_added_outlined
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
  ProtocolsMenu(
      {Key? key,
      required this.collection,
      required this.userAccount,
      required this.searchable})
      : super(key: key);

  final ProtocolCollection collection;
  bool searchable = false;
  final Account userAccount;

  @override
  State<ProtocolsMenu> createState() => _ProtocolsMenuState();
}

class _ProtocolsMenuState extends State<ProtocolsMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.collection.title),
          actions: widget.searchable
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
                          builder: (context) => ProtocolsMenu(
                              collection: item,
                              userAccount: widget.userAccount,
                              searchable: false)));
                } else if (item is ProtocolItem) {
                  launch(item.documentUri.toString());
                } else {
                  throw ErrorDescription(
                      'item must be either ProtocolCollection or ProtocolItem, is ${item.runtimeType} instead');
                }
              });
            }));
  }
}

class ProtocolsSearchPage extends StatefulWidget {
  const ProtocolsSearchPage(
      {Key? key, required this.searchableCollection, required this.userAccount})
      : super(key: key);

  final ProtocolCollection searchableCollection;
  final Account userAccount;

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
