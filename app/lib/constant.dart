import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ========== Padding Constants ==========
const KhorzontalPadding = 16.0;
const KTopPadding = 16.0;
const KHomeResturantLimit = 3;

// ========== Primary Colors ==========
const KprimaryColor = Color(0xFF5B3DF5); // StyleBox Violet (Primary Brand Color)
const KprimaryColorLight = Color(0xFFEEEAFF); // Lilac tint (surfaces, chips)
const KprimaryColorDark = Color(0xFF3A22B8); // Deep Violet
const KsecondaryColor = Color(0xFFEEEAFF); // Lilac tint
const KaccentColor = Color(0xFFFF6B6B); // Coral (deals, highlights)

// Brand gradient used by hero sections and the splash
const KbrandGradient = LinearGradient(
  colors: [Color(0xFF5B3DF5), Color(0xFF9B6BFF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ========== Dark Mode Colors ==========
const KdarkModeBgColor = Color(0xFF0F0E17); // Ink Background
const KdarkModeCardColor = Color(0xFF1B1A26); // Raised Card
const KdarkModeTextColor = Color(0xFFF2F0FF); // Near-white Text
const KdarkModeTextSecondary = Color(0xFFA9A5C0); // Muted Lavender

// ========== Light Mode Colors ==========
const KlightModeBgColor = Color(0xFFF7F6FB); // Soft lilac-white Background
const KlightModeCardColor = Color(0xFFFFFFFF); // White Cards/Surface
const KlightModeTextColor = Color(0xFF14121F); // Ink Text
const KlightModeTextSecondary = Color(0xFF6E6A80); // Gray-violet Text

const KdisabledColor = Color(0xFFC9C6D6); // Muted Color
const KdividerColor = Color(0xFFECEAF3); // Light Divider

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
