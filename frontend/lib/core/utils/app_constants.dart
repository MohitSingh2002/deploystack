class AppConstants {
  // static const String host = 'http://139.59.95.38:5001';
  static const String host = 'http://localhost:5001';
  static const String backendConnectionUrl = '$host/api';
  // static const String backendConnectionUrl = 'https://andrea-coal-coast-andale.trycloudflare.com/api';
  static const String socketId = 'deployment';
  static const String socketDeploymentEvent = 'deployment-event';

  static const Map<String, String> header = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const String someErrorOccurred = 'Some Error Occurred.';
}
