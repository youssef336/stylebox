import 'package:flutter_test/flutter_test.dart';
import 'package:stylebox/core/utils/hash_helper.dart';

void main() {
  group('HashHelper', () {
    test('sha256String is deterministic and hex encoded', () {
      final hash = HashHelper.sha256String('stylebox');
      expect(hash, HashHelper.sha256String('stylebox'));
      expect(hash, matches(RegExp(r'^[0-9a-f]{64}$')));
    });

    test('sha256Json changes when the payload changes', () {
      expect(
        HashHelper.sha256Json({'a': 1}),
        isNot(HashHelper.sha256Json({'a': 2})),
      );
    });
  });
}
