import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/deployment_listener.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/disconnect_deployment.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/join_deployment.dart';
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';

part 'deployment_logs_event.dart';
part 'deployment_logs_state.dart';

class DeploymentLogsBloc extends Bloc<DeploymentLogsEvent, DeploymentLogsState> {
  final JoinDeployment _joinDeployment;
  final DisconnectDeployment _disconnectDeployment;
  final DeploymentListener _deploymentListener;

  DeploymentLogsBloc({
    required JoinDeployment joinDeployment,
    required DisconnectDeployment disconnectDeployment,
    required DeploymentListener deploymentListener,
  })
      : _joinDeployment = joinDeployment,
        _disconnectDeployment = disconnectDeployment,
        _deploymentListener = deploymentListener,
  super(DeploymentLogsInitial()) {
    on<DeploymentLogsEvent>((event, emit) {
      // emit(DeploymentLogsState());
    });
    on<DeploymentLogsJoinDeploymentEvent>(_onDeploymentLogsJoinDeploymentEvent);
    on<DeploymentLogsDisconnectDeploymentEvent>(_onDeploymentLogsDisconnectDeploymentEvent);
    on<DeploymentLogsConnectSocketEvent>(_onDeploymentLogsConnectSocketEvent);
    on<DeploymentCompletedEvent>(_onDeploymentCompletedEvent);
    on<DeploymentFailedEvent>(_onDeploymentFailedEvent);
  }

  void _onDeploymentLogsJoinDeploymentEvent(DeploymentLogsJoinDeploymentEvent event, Emitter emit) async {
    _joinDeployment.call(NoParams());
    emit(DeploymentLogsNoDeploymentState());
  }

  void _onDeploymentLogsDisconnectDeploymentEvent(DeploymentLogsDisconnectDeploymentEvent event, Emitter emit) async {
    await _disconnectDeployment.call(NoParams());
  }

  void _onDeploymentLogsConnectSocketEvent(DeploymentLogsConnectSocketEvent event, Emitter emit) async {
    final res = await _deploymentListener.call(NoParams());

    await res.fold(
          (failure) {},
          (stream) async {
        await emit.forEach(
          stream,
          onData: (data) {
            if (data == 'deployment-completed') {
              add(DeploymentCompletedEvent());
              return state;
            } else if (data == 'deployment-failed') {
              add(DeploymentFailedEvent());
              return state;
            } else {
              final currentLogs = state is DeploymentLogsDataState ? (state as DeploymentLogsDataState).data : [];

              return DeploymentLogsDataState(
                isDataAvailable: true,
                data: [...currentLogs, data.toString()],
              );
            }
          },
        );
      },
    );
  }

  void _onDeploymentCompletedEvent(DeploymentCompletedEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 3,),);
    emit(DeploymentCompletedState());
  }

  void _onDeploymentFailedEvent(DeploymentFailedEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 3,),);
    emit(DeploymentFailedState());
  }
}
