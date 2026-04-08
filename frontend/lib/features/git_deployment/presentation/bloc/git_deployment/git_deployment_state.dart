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

  GitDeploymentSuccessState({required this.gitHubRepoList,});
}
