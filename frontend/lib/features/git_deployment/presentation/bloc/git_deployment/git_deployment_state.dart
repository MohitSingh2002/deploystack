part of 'git_deployment_bloc.dart';

@immutable
sealed class GitDeploymentState {}

final class GitDeploymentInitial extends GitDeploymentState {}

final class GitDeploymentLoadingState extends GitDeploymentState {}

final class GitDeploymentErrorState extends GitDeploymentState {
  final String message;

  GitDeploymentErrorState({required this.message,});
}

final class GitDeploymentSuccessState extends GitDeploymentState {
  final List<GitHubRepo> gitHubRepoList;
  final String? defaultBranchName;
  final List<GitHubRepoBranch>? gitHubRepoBranchList;
  final bool isFetchingBranches;

  GitDeploymentSuccessState({required this.gitHubRepoList, this.defaultBranchName, this.gitHubRepoBranchList, this.isFetchingBranches = false,});

  GitDeploymentSuccessState copyWith({List<GitHubRepo>? gitHubRepoList, String? defaultBranchName, List<GitHubRepoBranch>? gitHubRepoBranchList, bool? isFetchingBranches}) {
    return GitDeploymentSuccessState(
      gitHubRepoList: gitHubRepoList ?? this.gitHubRepoList,
      defaultBranchName: defaultBranchName ?? this.defaultBranchName,
      gitHubRepoBranchList: gitHubRepoBranchList ?? this.gitHubRepoBranchList,
      isFetchingBranches: isFetchingBranches ?? this.isFetchingBranches,
    );
  }
}
