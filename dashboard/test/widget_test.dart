import 'package:flutter_test/flutter_test.dart';
import 'package:stylebox_dashboard/core/helper_functions/parse_price.dart';

void main() {
  group('parsePrice', () {
    test('parses dot and comma decimals', () {
      expect(parsePrice('12.5'), 12.5);
      expect(parsePrice('12,5'), 12.5);
      expect(parsePrice('  40 '), 40);
    });

    test('returns null for empty or invalid input', () {
      expect(parsePrice(''), isNull);
      expect(parsePrice('   '), isNull);
      expect(parsePrice('abc'), isNull);
    });
  });
}
