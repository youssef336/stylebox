import 'dart:convert';

/// Local-only card snapshot for checkout (not PCI compliant).
class VisaCardModel {
  const VisaCardModel({
    required this.cardHolderName,
    required this.cardNumberDigits,
    required this.expiry,
  });

  final String cardHolderName;
  final String cardNumberDigits;
  final String expiry;

  String get last4 {
    final d = cardNumberDigits.replaceAll(RegExp(r'\s'), '');
    if (d.length < 4) return d;
    return d.substring(d.length - 4);
  }

  Map<String, dynamic> toJson() => {
    'cardHolderName': cardHolderName,
    'cardNumberDigits': cardNumberDigits,
    'expiry': expiry,
  };

  factory VisaCardModel.fromJson(Map<String, dynamic> json) {
    return VisaCardModel(
      cardHolderName: json['cardHolderName'] as String? ?? '',
      cardNumberDigits: json['cardNumberDigits'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
    );
  }

  String toStoredString() => jsonEncode(toJson());

  static VisaCardModel? tryParse(String raw) {
    if (raw.isEmpty) return null;
    try {
      return VisaCardModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
