import 'package:flutter/material.dart';

class ProtocolsMenu extends StatelessWidget {
  const ProtocolsMenu({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Item one. $text'),
          subtitle: Text('An example subtitle...'),
          onTap: () => {print('Tapped')},
        ),
        const ListTile(title: Text('Item two...')),
      ],
    );
  }
}
