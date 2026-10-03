import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashHelper {
  const HashHelper._();

  static String sha256String(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  static String passwordHash(String password) {
    return sha256String(password);
  }

  static String sha256Json(Map<String, dynamic> value) {
    final normalizedJson = jsonEncode(value);
    return sha256String(normalizedJson);
  }
}
