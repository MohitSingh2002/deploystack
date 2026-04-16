import 'package:deploystack/core/utils/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? socket;
  static SocketService? _instance;

  SocketService._internal() {
    socket = io.io(AppConstants.host, <String, dynamic> {
      'forceNew': true,
      'autoConnect': false,
    });

    socket!.onConnect((_) {});
    // socket!.connect();
    socket!.onConnectError((data) => print('onConnectError : $data'));
    socket!.onError((data) => print('onError : $data'));
  }

  static SocketService get instance {
    _instance ??= SocketService._internal();
    return _instance!;
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
    }
  }

  void connect() {
    if (socket != null && !socket!.connected) {
      socket!.connect();
    }
  }
}
