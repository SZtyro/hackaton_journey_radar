// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color alert = Color(0xffEF6C00);
  static const Color trashColor = Colors.red;

  // Base Colors
  static const lightBlueColor = Color(0xff00D3FF);
  static const secondLightBlueColor = Color(0xff0D77B2);
  static const blueColor = Color(0xFF3945FF);
  static const secondBlueColor = Color(0xFF2F34FE);

  // Main Button Colors
  static const darkMainButtonFirst = lightBlueColor;
  static const darkOnMainButton = Colors.white;
  static const darkPrimaryContainer = Colors.black;
  static const darkOnPrimaryContainer = Colors.white;
  static const lightMainButtonFirst = lightBlueColor;
  static const lightOnMainButton = Colors.white;
  static const lightPrimaryContainer = Colors.white;
  static const lightOnPrimaryContainer = Colors.black;

  // Secondary Button Colors
  static const darkSecondaryButtonFirst = blueColor;
  static const darkOnSecondaryButton = Colors.white;
  static const darkSecondaryButtonSecond = secondBlueColor;
  static const darkOnSecondaryButtonSecond = Colors.white;
  static const lightSecondaryButtonFirst = blueColor;
  static const lightOnSecondaryButton = Colors.white;
  static const lightSecondaryButtonSecond = secondBlueColor;
  static const lightOnSecondaryButtonSecond = Colors.white;

  // Background Colors
  static const darkBackground = Color(0xFF0A0A21);
  static const darkOnBackground = Colors.white;
  static const darkOnBackgroundSecond = Colors.white;
  static const lightBackground = Colors.white;
  static const lightOnBackground = Colors.black;
  static const lightOnBackgroundSecond = Color(0xFF444444);

  // Text Field Colors
  static const darkTextFieldBackground = Color(0xFF181B3D);
  static const darkTextFieldBorder = Color(0xFF323656);
  static const darkOnTextField = Colors.white;
  static const darkTextFieldIcon = Color(0xFF363A64);
  static const darkSecondaryTextFieldBorder = Color(0xFF9AAED5);
  static const lightTextFieldBackground = Colors.white;
  static const lightTextFieldBorder = Color(0xFFB3B3D9);
  static const lightOnTextField = Colors.black;
  static const lightTextFieldIcon = Color(0xFFB3B3D9);
  static const lightSecondaryTextFieldBorder = Colors.blueGrey;

  static const toastLightBlue = Color.fromARGB(123, 0, 213, 255);
  static const toastDarkishBlue = Color(0xff0D77B2);

  static const shadowColor = Colors.black;

  // Snackbar Colors
  static const darkSnackBar = Colors.red;
  static const darkOnSnackBar = Colors.white;
  static const lightSnackBar = Colors.red;
  static const lightOnSnackBar = Colors.white;

  static const transparent = Colors.transparent;

}

abstract class AppGradients {
  static const mainButtonGradient = LinearGradient(
    colors: [AppColors.lightBlueColor, AppColors.secondLightBlueColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const mainInvertedButtonGradient = LinearGradient(
    colors: [
      Color(0xFF5C5C5C),
      Color(0xFF333333),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const secondaryButtonGradient = LinearGradient(
    colors: [AppColors.blueColor, Color(0xFF506CFD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF09091F),
      AppColors.darkBackground,
      Color(0xFF0B1134),
    ],
  );

  static const lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.toastLightBlue,
      AppColors.toastDarkishBlue,
    ],
  );
}
