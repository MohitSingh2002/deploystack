import 'package:deploystack/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:deploystack/core/github_auth_checker/data/data_sources/github_auth_checker_remote_data_source.dart';
import 'package:deploystack/core/github_auth_checker/data/repositories/github_auth_checker_repository_impl.dart';
import 'package:deploystack/core/github_auth_checker/domain/repository/github_auth_checker_repository.dart';
import 'package:deploystack/core/github_auth_checker/domain/usecases/check_if_github_app_installed.dart';
import 'package:deploystack/core/github_auth_checker/presentation/bloc/git_authenticated/git_authenticated_bloc.dart';
import 'package:deploystack/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:deploystack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:deploystack/features/auth/domain/repository/auth_repository.dart';
import 'package:deploystack/features/auth/domain/usecases/current_user.dart';
import 'package:deploystack/features/auth/domain/usecases/user_sign_up.dart';
import 'package:deploystack/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initGithubAuth();

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => UserSignUp(authRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => CurrentUser(authRepository: serviceLocator())
  );

  serviceLocator.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      )
  );
}

void _initGithubAuth() {
  serviceLocator.registerFactory<GithubAuthCheckerRemoteDataSource>(
      () => GithubAuthCheckerRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<GithubAuthCheckerRepository>(
      () => GithubAuthCheckerRepositoryImpl(githubAuthCheckerRemoteDataSource: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => CheckIfGithubAppInstalled(githubAuthCheckerRepository: serviceLocator())
  );

  serviceLocator.registerLazySingleton<GitAuthenticatedBloc>(
      () => GitAuthenticatedBloc(
        checkIfGithubAppInstalled: serviceLocator()
      )
  );
}
