import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/gradients.dart';

class GradientBackgroundView extends StatelessWidget {
  const GradientBackgroundView({
    super.key,
    this.child,
    this.gradient = greyGradient,
    this.height,
  });

  final Widget? child;
  final double? height;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            color: AppColors.background,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(gradient: gradient),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(child: child),
          ),
        ],
      ),
    );
  }
}
