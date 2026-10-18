import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ========== Padding Constants ==========
const KhorzontalPadding = 16.0;
const KTopPadding = 16.0;
const KHomeResturantLimit = 3;

// ========== StyleBox "Atelier" palette ==========
// Bordeaux wine + champagne gold on warm ivory: an editorial, boutique look.
const KprimaryColor = Color(0xFF8E2C48); // Bordeaux (Primary Brand Color)
const KprimaryColorLight = Color(0xFFF6E8EC); // Blush tint (surfaces, chips)
const KprimaryColorDark = Color(0xFF5E1A2F); // Deep Merlot
const KsecondaryColor = Color(0xFFF6E8EC); // Blush tint
const KaccentColor = Color(0xFFC39A5B); // Champagne Gold (deals, highlights)
const KaccentColorLight = Color(0xFFF5ECDD); // Soft champagne wash

// Brand gradient used by hero sections and the splash
const KbrandGradient = LinearGradient(
  colors: [Color(0xFF5E1A2F), Color(0xFF8E2C48), Color(0xFFB0506B)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ========== Dark Mode Colors ==========
const KdarkModeBgColor = Color(0xFF15110F); // Espresso Background
const KdarkModeCardColor = Color(0xFF221C1A); // Raised Card
const KdarkModeTextColor = Color(0xFFF7F1EC); // Warm near-white Text
const KdarkModeTextSecondary = Color(0xFFB5AAA3); // Muted Taupe
const KdarkModePrimary = Color(0xFFE08AA2); // Rose (primary on dark)
const KdarkModeDivider = Color(0xFF342B28); // Dark hairline

// ========== Light Mode Colors ==========
const KlightModeBgColor = Color(0xFFFAF7F4); // Warm Ivory Background
const KlightModeCardColor = Color(0xFFFFFFFF); // White Cards/Surface
const KlightModeTextColor = Color(0xFF1E1816); // Espresso Ink Text
const KlightModeTextSecondary = Color(0xFF7A6F69); // Taupe Text
const KlightModeFieldColor = Color(0xFFF3EEEA); // Linen (input fill)

const KdisabledColor = Color(0xFFCFC6C0); // Muted Color
const KdividerColor = Color(0xFFEDE5E0); // Light Divider

// ========== Shape tokens ==========
const KradiusSmall = 10.0; // chips, badges, small tiles
const KradiusField = 12.0; // text fields
const KradiusCard = 18.0; // cards and sheets

const KisBoardingViewSeen = 'isBoardingViewSeen';

const KCupon = 'cupon';
const KCuponDiscount = 'cuponDiscount';

const KUserData = 'userData';
const KVisaCardLocal = 'visaCardLocal';
const Kpoints = 'points';
const Klocale = 'locale';
const Kavatar = 'avatar';
const KisRead = 'isRead';
const Knotification = 'notification';
const KSavedCardHolderName = 'saved_card_holder_name';
const KSavedCardLast4 = 'saved_card_last4';
const KSavedCardExpiryDate = 'saved_card_expiry_date';
const KSavedAddressName = 'saved_address_name';
const KSavedAddressEmail = 'saved_address_email';
const KSavedAddressLine = 'saved_address_line';
const KSavedAddressCity = 'saved_address_city';
const KSavedAddressFloor = 'saved_address_floor';
const KSavedAddressPhone = 'saved_address_phone';
const KOrderConfirmationPoints = 10;
