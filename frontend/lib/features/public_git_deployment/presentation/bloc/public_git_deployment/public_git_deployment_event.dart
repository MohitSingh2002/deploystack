part of 'public_git_deployment_bloc.dart';

@immutable
sealed class PublicGitDeploymentEvent {}

final class DeployGitProjectEvent extends PublicGitDeploymentEvent {
  final String cloneUrl;

  DeployGitProjectEvent({required this.cloneUrl,});
}
