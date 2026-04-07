import 'package:deploystack/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:deploystack/core/common/widgets/loading.dart';
import 'package:deploystack/core/github_auth_checker/presentation/bloc/git_authenticated/git_authenticated_bloc.dart';
import 'package:deploystack/core/theme/app_theme.dart';
import 'package:deploystack/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:deploystack/features/auth/presentation/pages/signup_page.dart';
import 'package:deploystack/features/home/presentation/pages/home_page.dart';
import 'package:deploystack/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await initDependencies();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
          BlocProvider(create: (_) => serviceLocator<GitAuthenticatedBloc>()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthIsUserLoggedInEvent());
    context.read<GitAuthenticatedBloc>().add(IsGitAuthenticatedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeployStack',
      theme: AppTheme.theme,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Scaffold(
              body: Loading(),
            );
          }
          if (state is AuthSuccess) {
            return HomePage();
          }
          return SignUpPage();
        },
      ),
    );
  }
}
