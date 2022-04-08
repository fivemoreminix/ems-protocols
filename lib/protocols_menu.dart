import 'dart:convert';

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

class ProtocolsMenu extends StatelessWidget {
  const ProtocolsMenu({Key? key, required this.collection}) : super(key: key);

  final ProtocolCollection collection;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: collection.items.length,
        itemBuilder: (BuildContext context, int index) {
          var item = collection.items[index];
          return ListTile(
            title: Text(item.title),
            onTap: () => {
              if (item is ProtocolCollection)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProtocolsMenu(collection: item)))
                }
              else if (item is ProtocolItem)
                {launch(item.documentUri.toString())}
              else
                {
                  throw ErrorDescription(
                      'item must be either ProtocolCollection or ProtocolItem, is ${item.runtimeType} instead')
                }
            },
          );
        });
  }
}
