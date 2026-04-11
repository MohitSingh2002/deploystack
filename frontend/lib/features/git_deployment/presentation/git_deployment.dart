import 'package:deploystack/core/common/widgets/app_button.dart';
import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';
import 'package:deploystack/features/git_deployment/presentation/bloc/git_deployment/git_deployment_bloc.dart';
import 'package:deploystack/features/git_deployment/presentation/widgets/git_deployment_drop_down.dart';
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
  GitHubRepoBranch? selectedRepoBranch;

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

            if (state is GitDeploymentSuccessState && state.isDeploymentSuccessful) {
              showSnackBar(context: context, content: 'Deployment Created.');
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

                    GitDeploymentDropDown<GitHubRepo>(
                      label: 'Select Repository',
                      selectedItem: selectedRepo,
                      itemList: state.gitHubRepoList.map((repo) {
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
                          selectedRepoBranch = null;
                          // selectedRepoBranch = GitHubRepoBranch(name: value!.defaultBranch,);
                        });
                        context.read<GitDeploymentBloc>().add(
                            GitDeploymentFetchRepositoryBranchesEvent(
                              gitHubRepo: selectedRepo!,));
                      },
                    ),

                    state.isFetchingBranches ? Container(
                      margin: EdgeInsets.only(top: 20.0,),
                      child: Loading(),
                    ) : SizedBox(),

                    state.gitHubRepoBranchList == null ? SizedBox() : const SizedBox(height: 20.0,),

                    state.gitHubRepoBranchList == null ? SizedBox() : GitDeploymentDropDown<GitHubRepoBranch>(
                      label: 'Select Branch',
                      selectedItem: selectedRepoBranch,
                      itemList: state.gitHubRepoBranchList!.map((repo) {
                        return DropdownMenuItem(
                          value: repo,
                          child: Text(
                            repo.name,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRepoBranch = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30.0,),

                    AppButton(
                      onPressed: selectedRepo == null || selectedRepoBranch == null ? null : () {
                        context.read<GitDeploymentBloc>().add(GitRepoDeploymentEvent(gitHubRepo: selectedRepo!, gitHubRepoBranch: selectedRepoBranch!));
                      },
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
