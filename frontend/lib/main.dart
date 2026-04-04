import 'package:deploystack/core/theme/app_theme.dart';
import 'package:deploystack/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:deploystack/features/auth/presentation/pages/signup_page.dart';
import 'package:deploystack/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeployStack',
      theme: AppTheme.theme,
      home: SignUpPage(),
    );
  }
}
