import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    switch (entry.value.runtimeType) {
      case LinkedHashMap:
      case Map:
        var c = parseProtocolCollectionJson(entry.value);
        if (c == null) {
          throw ErrorDescription('Protocol collection is empty');
        }
        c.title = entry.key;
        collection.items.add(c);
        break;
      case String:
        collection.items.add(ProtocolItem(
            title: entry.key, documentUri: Uri.parse(entry.value)));
        break;
      default:
        throw ErrorDescription(
            'Value of type ${entry.value.runtimeType} in Protocol JSON is not Map or String');
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
          return ListTile(
            title: Text(collection.items[index].title),
          );
        });
  }
}
