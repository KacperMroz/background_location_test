import 'package:backk_location_test/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton({super.key,
    @required this.label,
    this.width,
    this.height = 50.0,
    this.onPressed,
  });

  final String? label;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            label!,
            style: AppTextStyles.textButton(),
          ),
        ),
      ),
    );
  }
}
