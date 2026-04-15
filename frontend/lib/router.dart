import 'package:deploystack/core/utils/app_routes.dart';
import 'package:deploystack/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/common/widgets/loading.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'package:deploystack/features/projects/presentation/pages/projects_page.dart';

import 'features/project_deployment_logs/presentation/pages/project_deployment_logs_page.dart';
import 'init_dependencies.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}

final router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  refreshListenable: GoRouterRefreshStream(
    serviceLocator<AuthBloc>().stream,
  ),
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;

    final isLoading = authState is AuthLoading;
    final isLoggedIn = authState is AuthSuccess;

    final isLoadingRoute = state.matchedLocation == AppRoutes.loading;
    final isSignupRoute = state.matchedLocation == AppRoutes.signup;

    if (isLoggedIn && isLoadingRoute) {
      return AppRoutes.dashboard;
    }

    if (isLoading) {
      return isLoadingRoute ? null : AppRoutes.loading;
    }

    if (!isLoggedIn) {
      return isSignupRoute ? null : AppRoutes.signup;
    }

    if (isLoggedIn && isSignupRoute) {
      return AppRoutes.dashboard;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.loading,
      builder: (context, state) => const Scaffold(
        body: Loading(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child,);
      },
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: AppRoutes.projects,
          builder: (context, state) => const ProjectsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/project/logs',
      builder: (context, state) {
        final projectId = state.uri.queryParameters['projectId'] ?? '';
        return ProjectDeploymentLogsPage(projectId: projectId);
      },
    ),
  ],
);
