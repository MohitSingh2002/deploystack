import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String loading = '/loading';
  static const String signup = '/signup';
  static const String dashboard = '/';
  static const String projects = '/projects';

  static String getCurrentRoute({required BuildContext context,}) {
    return GoRouterState.of(context).matchedLocation;
  }
}
