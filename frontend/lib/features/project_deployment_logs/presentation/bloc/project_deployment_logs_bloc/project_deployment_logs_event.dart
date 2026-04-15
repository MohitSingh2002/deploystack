part of 'project_deployment_logs_bloc.dart';

@immutable
sealed class ProjectDeploymentLogsEvent {}

final class ProjectDeploymentLogsFetchEvent extends ProjectDeploymentLogsEvent {
  final String projectId;

  ProjectDeploymentLogsFetchEvent({required this.projectId,});
}
