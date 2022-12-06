import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({super.key,
    this.onMenuPressed,
    this.label,
    this.brightness,
    this.isBackArrow = true,
    this.onBackPressed,
    this.isMenuNeeded = true,
    this.onTextButtonPressed,
  });

  final VoidCallback? onMenuPressed;
  final String? label;
  final double? iconButtonSize = 30;
  final String? brightness;
  final bool? isBackArrow;
  final VoidCallback? onBackPressed;
  final bool? isMenuNeeded;
  final VoidCallback? onTextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isBackArrow!)
            _buildBackIconWithLabel(context)
          else
            Text(
              label!,
              style: AppTextStyles.toolbarLabel(brightness!),
            ),
          if (isMenuNeeded!) _buildHamburgerIcon(context)
        ],
      ),
    );
  }

  Widget _buildBackIconWithLabel(context) => Row(
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: iconButtonSize!,
              maxWidth: iconButtonSize!,
              minHeight: iconButtonSize!,
              maxHeight: iconButtonSize!,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              label!,
              style: AppTextStyles.toolbarLabel(brightness!),
            ),
          )
        ],
      );

  Widget _buildHamburgerIcon(BuildContext context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
          size: 30,
        ),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: iconButtonSize!,
          maxWidth: iconButtonSize!,
          minHeight: iconButtonSize!,
          maxHeight: iconButtonSize!,
        ),
      );

  @override
  Size get preferredSize => const Size(double.infinity, 80);
}
