import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle text({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14.0,
    Color color = AppColors.black,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontStyle: FontStyle.normal,
      fontSize: fontSize,
    );
  }

  static TextStyle textButton() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        fontFamily: 'Lato',
      );

  static TextStyle toolbarLabel(String brightness) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: brightness == 'light' ? Colors.black : Colors.white,
      );

  static TextStyle chooseRegion() =>
      const TextStyle(fontSize: 16, color: Colors.black);
}
