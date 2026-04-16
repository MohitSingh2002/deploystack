import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppButton extends StatelessWidget {

  Function()? onPressed;
  String buttonText;
  bool showIcon;
  IconData? icon;

  AppButton({super.key, 
    required this.onPressed,
    required this.buttonText,
    this.showIcon = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        disabledBackgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          showIcon ? const SizedBox(width: 8) : const SizedBox(),
          showIcon ? Icon(icon, color: AppColors.black, size: 18) : const SizedBox(),
        ],
      ),
    );
  }
}
