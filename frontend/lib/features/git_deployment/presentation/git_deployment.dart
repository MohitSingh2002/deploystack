import 'package:deploystack/core/common/widgets/app_button.dart';
import 'package:deploystack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/loading.dart';
import '../../../core/github_auth_checker/presentation/bloc/git_authenticated/git_authenticated_bloc.dart';

class GitDeployment extends StatefulWidget {
  const GitDeployment({super.key});

  @override
  State<GitDeployment> createState() => _GitDeploymentState();
}

class _GitDeploymentState extends State<GitDeployment> {
  String? selectedRepo;

  final List<String> repos = [
    "repo-frontend",
    "repo-backend",
    "repo-dashboard",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GitAuthenticatedBloc, GitAuthenticatedState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GitAuthenticatedLoadingState) {
          return const Loading();
        }

        if ((state is IsGitAuthenticatedState) && !state.isAuthenticated) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardPrimaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "REPOSITORY CONFIGURATION",
                style: TextStyle(
                  color: AppColors.white38,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.white12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: AppColors.cardPrimaryColor,
                    value: selectedRepo,
                    hint: const Text(
                      "Select Repository",
                      style: TextStyle(color: AppColors.white54),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.white54),
                    isExpanded: true,
                    items: repos.map((repo) {
                      return DropdownMenuItem(
                        value: repo,
                        child: Text(
                          repo,
                          style: const TextStyle(color: AppColors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRepo = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              AppButton(
                onPressed: selectedRepo == null ? null : () {},
                buttonText: 'Deploy',
                showIcon: true,
                icon: Icons.rocket_launch,
              ),
            ],
          ),
        );
      },
    );
  }
}
