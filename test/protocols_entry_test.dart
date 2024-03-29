import 'package:ems_protocols/protocols/protocols_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get item by title', () {
    ProtocolCollection collection = ProtocolCollection('', '', [
      ProtocolItem('Entry 1', ''),
      ProtocolCollection('', '', [
        ProtocolItem('Entry 2', ''),
        ProtocolItem('Entry 3', ''),
      ])
    ]);

    var entry1 = collection.getItemByTitle('Entry 1');
    var entry2 = collection.getItemByTitle('Entry 2');
    var entry3 = collection.getItemByTitle('Entry 3');

    assert(entry1 != null);
    assert(entry2 != null);
    assert(entry3 != null);

    expect(entry1!.title, 'Entry 1');
    expect(entry2!.title, 'Entry 2');
    expect(entry3!.title, 'Entry 3');
  });
}
