import 'dart:async';

import 'package:deploystack/core/utils/app_constants.dart';
import 'package:deploystack/features/deployment_logs/data/data_sources/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract interface class DeploymentSocketRemoteDataSource {
  Future<void> joinDeployment();

  Future<void> disconnectDeployment();

  Stream<dynamic> deploymentListener();
}

class DeploymentSocketRemoteDataSourceImpl implements DeploymentSocketRemoteDataSource {
  @override
  Future<void> joinDeployment() async {
    final socketService = SocketService.instance.socket!;

    socketService.onConnect((_) {
      socketService.emit(AppConstants.socketId);
    });

    // socketService.emit(AppConstants.socketId);
  }

  @override
  Future<void> disconnectDeployment() async {
    final socketService = SocketService.instance;

    socketService.disconnect();
  }

  @override
  Stream<dynamic> deploymentListener() {
    final socketService = SocketService.instance.socket!;

    final controller = StreamController<dynamic>();

    socketService.off(AppConstants.socketDeploymentEvent);
    socketService.on(AppConstants.socketDeploymentEvent, (data) {
      controller.add(data);
    });

    SocketService.instance.connect();

    return controller.stream;
  }
}
