part of 'git_deployment_bloc.dart';

@immutable
sealed class GitDeploymentEvent {}

final class GitDeploymentFetchRepositoriesEvent extends GitDeploymentEvent {}
