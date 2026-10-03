import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Initial Tests', () {
    test('Simple math test to verify CI/CD pipeline', () {
      // Setup
      int a = 10;
      int b = 20;

      // Execute
      int result = a + b;

      // Verify
      expect(result, 30);
    });
  });
}