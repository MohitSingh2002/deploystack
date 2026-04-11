part of 'git_deployment_bloc.dart';

@immutable
sealed class GitDeploymentEvent {}

final class GitDeploymentFetchRepositoriesEvent extends GitDeploymentEvent {}

final class GitDeploymentFetchRepositoryBranchesEvent extends GitDeploymentEvent {
  final GitHubRepo gitHubRepo;

  GitDeploymentFetchRepositoryBranchesEvent({required this.gitHubRepo,});
}

final class GitRepoDeploymentEvent extends GitDeploymentEvent {
  final GitHubRepo gitHubRepo;
  final GitHubRepoBranch gitHubRepoBranch;

  GitRepoDeploymentEvent({
    required this.gitHubRepo,
    required this.gitHubRepoBranch,
  });
}
