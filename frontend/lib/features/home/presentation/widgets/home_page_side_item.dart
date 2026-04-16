import 'package:deploystack/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class HomePageSideItem extends StatelessWidget {

  IconData icon;
  String title;
  bool active = false;
  String route;

  HomePageSideItem({super.key, required this.icon, required this.title, this.active = false, required this.route,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (AppRoutes.getCurrentRoute(context: context) != route) {
          context.replace(route);
        }
      },
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
