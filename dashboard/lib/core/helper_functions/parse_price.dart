/// Parses a user-typed price, accepting both `.` and `,` as the decimal
/// separator (Arabic keyboards often produce a comma).
double? parsePrice(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(',', '.'));
}
