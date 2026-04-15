import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/common/widgets/loading.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'package:deploystack/features/projects/presentation/projects_page.dart';

import 'init_dependencies.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(
    serviceLocator<AuthBloc>().stream,
  ),
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;

    final isLoading = authState is AuthLoading;
    final isLoggedIn = authState is AuthSuccess;

    final isLoadingRoute = state.matchedLocation == '/loading';
    final isSignupRoute = state.matchedLocation == '/signup';

    if (isLoggedIn && isLoadingRoute) {
      return '/';
    }

    if (isLoading) {
      return isLoadingRoute ? null : '/loading';
    }

    if (!isLoggedIn) {
      return isSignupRoute ? null : '/signup';
    }

    if (isLoggedIn && isSignupRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const Scaffold(
        body: Loading(),
      ),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectsPage(),
    ),
  ],
);
