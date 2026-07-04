import 'package:local_store/local_store.dart';
import 'package:test/test.dart';

void main() {
  test('names the local store module', () {
    expect(const LocalStoreModule('tasks').name, 'tasks');
  });
}

