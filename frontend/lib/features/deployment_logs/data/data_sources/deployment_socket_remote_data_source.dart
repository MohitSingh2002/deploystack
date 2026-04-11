import 'dart:async';

import 'package:deploystack/core/utils/app_constants.dart';
import 'package:deploystack/features/deployment_logs/data/data_sources/socket_service.dart';

abstract interface class DeploymentSocketRemoteDataSource {
  Future<void> joinDeployment();

  Future<void> disconnectDeployment();

  Stream<dynamic> deploymentListener();
}

class DeploymentSocketRemoteDataSourceImpl implements DeploymentSocketRemoteDataSource {
  @override
  Future<void> joinDeployment() async {
    final _socketService = SocketService.instance.socket!;

    _socketService.emit(AppConstants.socketId);
  }

  @override
  Future<void> disconnectDeployment() async {
    final _socketService = SocketService.instance;

    _socketService.disconnect();
  }

  @override
  Stream<dynamic> deploymentListener() {
    final _socketService = SocketService.instance.socket!;

    final controller = StreamController<dynamic>();

    _socketService.off(AppConstants.socketDeploymentEvent);
    _socketService.on(AppConstants.socketDeploymentEvent, (data) {
      controller.add(data);
    });

    return controller.stream;
  }
}
