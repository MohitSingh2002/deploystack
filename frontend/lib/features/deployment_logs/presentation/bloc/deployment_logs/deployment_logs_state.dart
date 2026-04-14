part of 'deployment_logs_bloc.dart';

@immutable
sealed class DeploymentLogsState {}

final class DeploymentLogsInitial extends DeploymentLogsState {}

final class DeploymentLogsNoDeploymentState extends DeploymentLogsState {}

final class DeploymentLogsDataState extends DeploymentLogsState{
  final bool isDataAvailable;
  final List<String> data;

  DeploymentLogsDataState({this.isDataAvailable = false, this.data = const [],});

  DeploymentLogsDataState copyWith({bool? isDataAvailable, List<String>? data}) {
    return DeploymentLogsDataState(
      isDataAvailable: isDataAvailable ?? this.isDataAvailable,
      data: data ?? this.data,
    );
  }
}

final class DeploymentCompletedState extends DeploymentLogsState {}

final class DeploymentFailedState extends DeploymentLogsState {}
