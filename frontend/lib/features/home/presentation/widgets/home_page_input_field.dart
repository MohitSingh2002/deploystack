import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomePageInputField extends StatelessWidget {

  String hint;

  HomePageInputField({super.key, required this.hint,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.white38),
        filled: true,
        fillColor: AppColors.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
