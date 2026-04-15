part of 'project_deployment_logs_bloc.dart';

@immutable
sealed class ProjectDeploymentLogsState {}

final class ProjectDeploymentLogsInitial extends ProjectDeploymentLogsState {}

final class ProjectDeploymentLogsLoadingState extends ProjectDeploymentLogsState {}

final class ProjectDeploymentLogsFailureState extends ProjectDeploymentLogsState {
  final String message;

  ProjectDeploymentLogsFailureState({required this.message,});
}

final class ProjectDeploymentNoLogsSuccessState extends ProjectDeploymentLogsState {}

final class ProjectDeploymentLogsSuccessState extends ProjectDeploymentLogsState {
  final List<ProjectDeploymentLog> projectDeploymentLogList;

  ProjectDeploymentLogsSuccessState({required this.projectDeploymentLogList,});
}
