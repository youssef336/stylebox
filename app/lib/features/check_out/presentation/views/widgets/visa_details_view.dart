// ignore_for_file: unchecked_use_of_nullable_value

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/services/visa_card_prefs_services.dart';
import 'package:stylebox/core/utils/text_styles.dart';
import 'package:stylebox/core/widgets/build_app_bar.dart';
import 'package:stylebox/core/widgets/custom_buttom.dart';
import 'package:stylebox/features/check_out/data/models/visa_card_model.dart';
import 'package:stylebox/generated/l10n.dart';

String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

bool _validExpiryDigits(String digits) {
  if (digits.length != 4) return false;
  final mm = int.tryParse(digits.substring(0, 2));
  if (mm == null || mm < 1 || mm > 12) return false;
  return true;
}

OutlineInputBorder _outlineBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
  );
}

class VisaDetailsView extends StatefulWidget {
  const VisaDetailsView({super.key});

  @override
  State<VisaDetailsView> createState() => _VisaDetailsViewState();
}

class _VisaDetailsViewState extends State<VisaDetailsView> {
  final GlobalKey<FormState> _ccFormKey = GlobalKey<FormState>();
  int _formKeySeed = 0;

  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;

  VisaCardModel? _savedCardRow;

  @override
  void initState() {
    super.initState();
    if (VisaCardPrefsServices.hasSavedCard()) {
      final saved = VisaCardPrefsServices.loadCard();
      _savedCardRow = saved;
      _cardNumber = saved?.cardNumberDigits ?? '';
      _expiryDate = saved?.expiry ?? '';
      _cardHolderName = saved?.cardHolderName ?? '';
      _cvvCode = '';
    }
  }

  void _onCreditCardModelChange(CreditCardModel model) {
    setState(() {
      _cardNumber = model.cardNumber;
      _expiryDate = model.expiryDate;
      _cardHolderName = model.cardHolderName;
      _cvvCode = model.cvvCode;
      _isCvvFocused = model.isCvvFocused;
    });
  }

  Future<void> _onDeleteSaved() async {
    await VisaCardPrefsServices.clearCard();
    if (!mounted) return;
    setState(() {
      _savedCardRow = null;
      _cardNumber = '';
      _expiryDate = '';
      _cardHolderName = '';
      _cvvCode = '';
      _isCvvFocused = false;
      _formKeySeed++;
    });
  }

  Future<void> _onSave() async {
    final formState = _ccFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    final digits = _digitsOnly(_cardNumber);
    final expDigits = _digitsOnly(_expiryDate);
    if (expDigits.length != 4 || !_validExpiryDigits(expDigits)) return;

    final expiryFormatted =
        '${expDigits.substring(0, 2)}/${expDigits.substring(2, 4)}';
    final cvvDigits = _digitsOnly(_cvvCode);
    if (cvvDigits.length < 3) return;

    await VisaCardPrefsServices.saveCard(
      VisaCardModel(
        cardHolderName: _cardHolderName.trim(),
        cardNumberDigits: digits,
        expiry: expiryFormatted,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final scheme = Theme.of(context);
    final cardWidth = (MediaQuery.sizeOf(context).width - 32).clamp(
      260.0,
      420.0,
    );

    final fieldFill = scheme.inputDecorationTheme.fillColor;

    final inputConfiguration = InputConfiguration(
      cardNumberDecoration: InputDecoration(
        labelText: s.visaDetailsCardNumber,
        hintText: s.visaDetailsCardNumber,
        filled: true,
        fillColor: fieldFill,
        border: _outlineBorder(context),
        enabledBorder: _outlineBorder(context),
        focusedBorder: _outlineBorder(context),
      ),
      expiryDateDecoration: InputDecoration(
        labelText: s.visaDetailsExpiry,
        hintText: s.visaDetailsExpiry,
        filled: true,
        fillColor: fieldFill,
        border: _outlineBorder(context),
        enabledBorder: _outlineBorder(context),
        focusedBorder: _outlineBorder(context),
      ),
      cvvCodeDecoration: InputDecoration(
        labelText: s.visaDetailsCvv,
        hintText: s.visaDetailsCvv,
        filled: true,
        fillColor: fieldFill,
        border: _outlineBorder(context),
        enabledBorder: _outlineBorder(context),
        focusedBorder: _outlineBorder(context),
      ),
      cardHolderDecoration: InputDecoration(
        labelText: s.visaDetailsCardHolder,
        filled: true,
        fillColor: fieldFill,
        border: _outlineBorder(context),
        enabledBorder: _outlineBorder(context),
        focusedBorder: _outlineBorder(context),
      ),
      cardNumberTextStyle: AppTextStyles.cairoRegular.copyWith(
        color: scheme.colorScheme.onSurface,
      ),
      expiryDateTextStyle: AppTextStyles.cairoRegular.copyWith(
        color: scheme.colorScheme.onSurface,
      ),
      cvvCodeTextStyle: AppTextStyles.cairoRegular.copyWith(
        color: scheme.colorScheme.onSurface,
      ),
      cardHolderTextStyle: AppTextStyles.cairoRegular.copyWith(
        color: scheme.colorScheme.onSurface,
      ),
    );

    return Scaffold(
      appBar: buildAppbar(
        context,
        title: s.visaDetailsTitle,
        showNotification: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              if (_savedCardRow != null && VisaCardPrefsServices.hasSavedCard())
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0x33D9D9D9),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.visaDetailsSavedLabel,
                              style: AppTextStyles.cairoRegular.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.visaDetailsEndsWith(_savedCardRow!.last4),
                              style: AppTextStyles.cairoRegular.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: s.visaDetailsDelete,
                        onPressed: _onDeleteSaved,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              Center(
                child: CreditCardWidget(
                  cardNumber: _cardNumber,
                  expiryDate: _expiryDate,
                  cardHolderName: _cardHolderName,
                  cvvCode: _cvvCode,
                  showBackView: _isCvvFocused,
                  onCreditCardWidgetChange: (_) {},
                  width: cardWidth,
                  height: cardWidth * 0.5714,
                  cardBgColor: const Color(0xFF000000),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.6,
                    height: 1.15,
                    fontFamily: 'monospace',
                  ),
                  labelCardHolder: s.visaDetailsCardHolder,
                  labelValidThru: s.visaDetailsExpiry,
                  labelExpiredDate: s.visaDetailsExpiry,
                  isHolderNameVisible: true,
                  chipColor: const Color(0xFFC8C8C8),
                  obscureCardNumber: false,
                  obscureCardCvv: true,
                  enableFloatingCard: false,
                  isSwipeGestureEnabled: false,
                  padding: 18,
                  animationDuration: const Duration(milliseconds: 550),
                  isChipVisible: true,
                  cardType: CardType.visa,
                ),
              ),
              const SizedBox(height: 8),
              CreditCardForm(
                key: ValueKey(_formKeySeed),
                formKey: _ccFormKey,
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cardHolderName: _cardHolderName,
                cvvCode: _cvvCode,
                onCreditCardModelChange: _onCreditCardModelChange,
                obscureCvv: true,
                obscureNumber: false,
                disableCardNumberAutoFillHints: true,
                autovalidateMode: AutovalidateMode.disabled,
                inputConfiguration: inputConfiguration,
                numberValidationMessage: s.onSignupTextFeils,
                dateValidationMessage: s.onSignupTextFeils,
                cvvValidationMessage: s.onSignupTextFeils,
                cardNumberValidator: (value) {
                  final d = _digitsOnly(value ?? '');
                  if (d.length < 12) return s.onSignupTextFeils;
                  return null;
                },
                expiryDateValidator: (value) {
                  final d = _digitsOnly(value ?? '');
                  if (!_validExpiryDigits(d)) return s.onSignupTextFeils;
                  return null;
                },
                cvvValidator: (value) {
                  final d = _digitsOnly(value ?? '');
                  if (d.length < 3) return s.onSignupTextFeils;
                  return null;
                },
                cardHolderValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return s.onSignupTextFeils;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButtom(text: s.visaDetailsSave, onPressed: _onSave),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
