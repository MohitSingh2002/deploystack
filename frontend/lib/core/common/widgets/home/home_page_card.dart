import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class HomePageCard extends StatelessWidget {

  bool showIcon;
  Widget? icon;
  String title;
  String description;
  Widget child;

  HomePageCard({
    this.showIcon = false,
    this.icon,
    required this.title,
    required this.description,
    required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon && icon != null)
            icon!,
          if (showIcon && icon != null)
            const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
