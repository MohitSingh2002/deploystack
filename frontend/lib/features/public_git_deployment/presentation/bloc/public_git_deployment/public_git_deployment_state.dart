part of 'public_git_deployment_bloc.dart';

@immutable
sealed class PublicGitDeploymentState {}

final class PublicGitDeploymentInitial extends PublicGitDeploymentState {}

final class PublicGitDeploymentLoadingState extends PublicGitDeploymentState {}

final class PublicGitDeploymentErrorState extends PublicGitDeploymentState {
  final String message;

  PublicGitDeploymentErrorState({required this.message,});
}

final class PublicGitDeploymentSuccessState extends PublicGitDeploymentState {}
