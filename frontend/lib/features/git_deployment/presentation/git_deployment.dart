import 'package:deploystack/core/common/widgets/app_button.dart';
import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/presentation/bloc/git_deployment/git_deployment_bloc.dart';
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
  GitHubRepo? selectedRepo;

  @override
  void initState() {
    super.initState();

    context.read<GitDeploymentBloc>().add(
        GitDeploymentFetchRepositoriesEvent());
  }

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

        return BlocConsumer<GitDeploymentBloc, GitDeploymentState>(
          listener: (context, state) {
            if (state is GitDeploymentErrorState) {
              showSnackBar(context: context, content: state.message,);
            }
          },
          builder: (context, state) {
            if (state is GitDeploymentLoadingState) {
              return Loading();
            }

            if (state is GitDeploymentSuccessState) {
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
                        child: DropdownButton<GitHubRepo>(
                          dropdownColor: AppColors.cardPrimaryColor,
                          value: selectedRepo,
                          hint: const Text(
                            "Select Repository",
                            style: TextStyle(color: AppColors.white54),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.white54),
                          isExpanded: true,
                          items: state.gitHubRepoList.map((repo) {
                            return DropdownMenuItem(
                              value: repo,
                              child: Text(
                                repo.fullName,
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
            }

            return SizedBox();
          },
        );
      },
    );
  }
}
