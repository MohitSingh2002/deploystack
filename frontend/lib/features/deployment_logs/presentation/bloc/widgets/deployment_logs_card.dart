import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class DeploymentLogsCard extends StatelessWidget {
  String text;

  DeploymentLogsCard({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.white,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
