import 'package:flutter/painting.dart';

int expectedBackendVersion = 1;

final privacyPolicyUrl = Uri.https("saraka.firebaseapp.com", "/privacy-policy");

abstract class SarakaColor {
  static const white = Color(0xfff0f4f8);
  static const darkWhite = Color(0xffe1e8ef);
  static const lightGray = Color(0xffc8d6e5);
  static const darkGray = Color(0xff8395a7);
  static const lightBlack = Color(0xff576574);
  static const darkBlack = Color(0xff222f3e);
  static const lightCyan = Color(0xff48dbfb);
  static const darkCyan = Color(0xff0abde3);
  static const lightYellow = Color(0xfffeca57);
  static const darkYellow = Color(0xffff9f43);
  static const lightRed = Color(0xffff6b6b);
  static const darkRed = Color(0xffee5253);
  static const lightGreen = Color(0xff1dd1a1);
  static const darkGreen = Color(0xff10ac84);
  static const lightBlue = Color(0xff54a0ff);
  static const darkBlue = Color(0xff2e86de);
}

abstract class SarakaFontFamily {
  static const rubik = 'Rubik';
}

abstract class SarakaFontWeight {
  static const regular = FontWeight.w400;
  static const bold = FontWeight.w600;
  static const light = FontWeight.w300;
}

abstract class SarakaTextStyle {
  static const body = TextStyle(
    fontFamily: SarakaFontFamily.rubik,
    fontWeight: SarakaFontWeight.regular,
    fontSize: 16,
    color: SarakaColor.darkBlack,
  );

  static const heading = TextStyle(
    fontFamily: SarakaFontFamily.rubik,
    fontWeight: SarakaFontWeight.regular,
    fontSize: 18,
    color: SarakaColor.darkBlack,
  );

  static const body2 = TextStyle(
    fontFamily: SarakaFontFamily.rubik,
    fontWeight: SarakaFontWeight.regular,
    fontSize: 13,
    color: SarakaColor.darkBlack,
  );

  static const multilineBody = TextStyle(
    fontFamily: SarakaFontFamily.rubik,
    fontWeight: SarakaFontWeight.regular,
    fontSize: 16,
    height: 1.25,
    color: SarakaColor.darkBlack,
  );

  static const multilineBody2 = TextStyle(
    fontFamily: SarakaFontFamily.rubik,
    fontWeight: SarakaFontWeight.regular,
    fontSize: 13,
    height: 1.25,
    color: SarakaColor.darkBlack,
  );
}
