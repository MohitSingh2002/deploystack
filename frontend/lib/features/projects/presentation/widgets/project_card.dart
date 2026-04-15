import 'package:deploystack/features/projects/domain/entities/project.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProjectCard extends StatelessWidget {
  Project project;

  ProjectCard({required this.project,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.gitHubProject?.fullName ?? '',
                  style: const TextStyle(
                    color: AppColors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.buttonColor),
              ),
              child: Text(
                ":${project.port}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.buttonColor,
                ),
              ),
            ),
          ),

          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              '  ${project.gitHubProject!.formattedCreatedAt}',
              style: const TextStyle(
                color: AppColors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
