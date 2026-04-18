import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class HomePageInputField extends StatelessWidget {

  String hint;
  TextEditingController controller;

  HomePageInputField({super.key, required this.hint, required this.controller,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
