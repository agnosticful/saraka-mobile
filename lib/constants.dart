import 'package:flutter/painting.dart';

int expectedBackendVersion = 1;

abstract class SarakaColors {
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

abstract class SarakaFonts {
  static const rubik = 'Rubik';
}

abstract class SarakaTextStyles {
  static const _base = TextStyle(
    fontFamily: SarakaFonts.rubik,
  );
  static final body = _base.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: SarakaColors.darkGray,
  );
  static final multilineBody = body.apply(heightFactor: 1.25);
  static final body2 = body.apply(fontSizeFactor: .8125);
  static final multilineBody2 = body2.apply(heightFactor: 1.25);
  static final heading = _base.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: SarakaColors.lightBlack,
  );
  static final appBarTitle = _base.copyWith();
  static final buttonLabel = _base.copyWith(fontWeight: FontWeight.w500);
}
