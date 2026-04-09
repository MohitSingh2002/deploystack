import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class GitDeploymentDropDown<Type> extends StatelessWidget {
  String label;
  Type? selectedItem;
  List<DropdownMenuItem<Type>>? itemList;
  Function(Type?)? onChanged;

  GitDeploymentDropDown({super.key, required this.label, required this.selectedItem, required this.itemList, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Type>(
          dropdownColor: AppColors.cardPrimaryColor,
          value: selectedItem,
          hint: Text(
            label,
            style: TextStyle(color: AppColors.white54),
          ),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.white54),
          isExpanded: true,
          items: itemList,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
