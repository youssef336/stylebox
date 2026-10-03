import 'package:flutter/material.dart';

abstract class AppTextStyles {
  //===== Poppins (Default Font) =====//
  static const TextStyle bodySmallRegular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle heading5Bold = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodySmallSemibold = TextStyle(
    fontSize: 13,
    fontFamily: "Cairo",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodySmallSemibold2 = TextStyle(
    fontSize: 13,
    fontFamily: "Cairo",
    fontWeight: FontWeight.w700,
  );
  static const TextStyle bodySmallSemibold1 = TextStyle(
    fontSize: 13,
    fontFamily: "Cairo",
    fontWeight: FontWeight.w400,
    height: 1.60,
  );

  static const TextStyle bodysmallBold = TextStyle(
    fontSize: 13,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyBaseBold = TextStyle(
    fontSize: 16,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle poppinsMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLargeBold = TextStyle(
    fontSize: 19,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyXSmallSemibold = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyBaseRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyXSmallRegular = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyBaseSemibold = TextStyle(
    fontSize: 16,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle heading5Semibold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  //===== Cairo =====//
  static const TextStyle cairoBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Cairo',
  );
  static const TextStyle cairoBold19 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    fontFamily: 'Cairo',
  );

  static const TextStyle cairoRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Cairo',
  );

  static const TextStyle cairoMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Cairo',
  );

  //===== DM Sans =====//
  static const TextStyle dmSansBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'DMSans',
  );

  //===== Roboto =====//
  static const TextStyle robotoRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );
}
