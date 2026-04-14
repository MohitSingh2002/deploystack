part of 'deployment_logs_bloc.dart';

@immutable
sealed class DeploymentLogsEvent {}

final class DeploymentLogsJoinDeploymentEvent extends DeploymentLogsEvent {}

final class DeploymentLogsDisconnectDeploymentEvent extends DeploymentLogsEvent {}

final class DeploymentLogsConnectSocketEvent extends DeploymentLogsEvent {}

final class DeploymentCompletedEvent extends DeploymentLogsEvent {}

final class DeploymentFailedEvent extends DeploymentLogsEvent {}
