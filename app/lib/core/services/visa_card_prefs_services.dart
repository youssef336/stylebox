import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/features/check_out/data/models/visa_card_model.dart';

class VisaCardPrefsServices {
  VisaCardPrefsServices._();

  static bool hasSavedCard() {
    final card = VisaCardModel.tryParse(Prefs.getString(KVisaCardLocal));
    return card != null &&
        card.cardHolderName.isNotEmpty &&
        card.cardNumberDigits.replaceAll(RegExp(r'\s'), '').length >= 4 &&
        card.expiry.isNotEmpty;
  }

  static VisaCardModel? loadCard() {
    return VisaCardModel.tryParse(Prefs.getString(KVisaCardLocal));
  }

  static Future<void> saveCard(VisaCardModel model) async {
    await Prefs.setString(KVisaCardLocal, model.toStoredString());
  }

  static Future<void> clearCard() async {
    await Prefs.setString(KVisaCardLocal, '');
  }
}
