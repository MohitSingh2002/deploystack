import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomePageSideItem extends StatelessWidget {

  IconData icon;
  String title;
  bool active = false;

  HomePageSideItem({required this.icon, required this.title, this.active = false,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: active ? AppColors.buttonColor : AppColors.white54),
      title: Text(
        title,
        style: TextStyle(
          color: active ? AppColors.white : AppColors.white54,
        ),
      ),
    );
  }
}
