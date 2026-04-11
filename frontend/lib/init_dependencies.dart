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
import 'package:deploystack/features/deployment_logs/data/data_sources/deployment_socket_remote_data_source.dart';
import 'package:deploystack/features/deployment_logs/data/repositories/deployment_logs_repository_impl.dart';
import 'package:deploystack/features/deployment_logs/domain/repository/deployment_logs_repository.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/deployment_listener.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/disconnect_deployment.dart';
import 'package:deploystack/features/deployment_logs/domain/usecases/join_deployment.dart';
import 'package:deploystack/features/deployment_logs/presentation/bloc/deployment_logs/deployment_logs_bloc.dart';
import 'package:deploystack/features/git_auth/data/data_sources/git_auth_remote_data_source.dart';
import 'package:deploystack/features/git_auth/data/repositories/git_auth_repository_impl.dart';
import 'package:deploystack/features/git_auth/domain/repository/git_auth_repository.dart';
import 'package:deploystack/features/git_auth/domain/usecases/connect_github.dart';
import 'package:deploystack/features/git_auth/presentation/bloc/git_auth/git_auth_bloc.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/deploy_git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/data/repositories/git_deployment_repository_impl.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:deploystack/features/git_deployment/domain/usecases/deploy_git_repository.dart';
import 'package:deploystack/features/git_deployment/domain/usecases/fetch_user_github_repositories.dart';
import 'package:deploystack/features/git_deployment/presentation/bloc/git_deployment/git_deployment_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/git_deployment/data/data_sources/git_hub_repo_branch_remote_data_source.dart';
import 'features/git_deployment/domain/usecases/fetch_github_repository_branches.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initGithubAuth();
  _initGitAuth();
  _initGitDeployment();
  _initDeploymentLogs();

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

void _initGitAuth() {
  serviceLocator.registerFactory<GitAuthRemoteDataSource>(
      () => GitAuthRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<GitAuthRepository>(
      () => GitAuthRepositoryImpl(gitAuthRemoteDataSource: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => ConnectGithub(gitAuthRepository: serviceLocator())
  );

  serviceLocator.registerLazySingleton<GitAuthBloc>(
      () => GitAuthBloc(
        connectGithub: serviceLocator()
      )
  );
}

void _initGitDeployment() {
  serviceLocator.registerFactory<GitHubRepoRemoteDataSource>(
      () => GitHubRepoRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<GitHubRepoBranchRemoteDataSource>(
      () => GitHubRepoBranchRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<DeployGitHubRepoRemoteDataSource>(
      () => DeployGitHubRepoRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<GitDeploymentRepository>(
      () => GitDeploymentRepositoryImpl(
          gitHubRepoRemoteDataSource: serviceLocator(),
          gitHubRepoBranchRemoteDataSource: serviceLocator(),
          deployGitHubRepoRemoteDataSource: serviceLocator(),
      )
  );

  serviceLocator.registerFactory(
      () => FetchUserGithubRepositories(gitDeploymentRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => FetchGithubRepositoryBranches(gitDeploymentRepository: serviceLocator())
  );
  
  serviceLocator.registerFactory(
      () => DeployGitRepository(gitDeploymentRepository: serviceLocator())
  );

  serviceLocator.registerLazySingleton<GitDeploymentBloc>(
      () => GitDeploymentBloc(
        fetchUserGithubRepositories: serviceLocator(),
        fetchGithubRepositoryBranches: serviceLocator(),
        deployGitRepository: serviceLocator(),
      )
  );
}

void _initDeploymentLogs() {
  serviceLocator.registerFactory<DeploymentSocketRemoteDataSource>(
      () => DeploymentSocketRemoteDataSourceImpl()
  );

  serviceLocator.registerFactory<DeploymentLogsRepository>(
      () => DeploymentLogsRepositoryImpl(deploymentSocketRemoteDataSource: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => JoinDeployment(deploymentLogsRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => DisconnectDeployment(deploymentLogsRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
      () => DeploymentListener(deploymentLogsRepository: serviceLocator())
  );

  serviceLocator.registerLazySingleton<DeploymentLogsBloc>(
      () => DeploymentLogsBloc(
        joinDeployment: serviceLocator(),
        disconnectDeployment: serviceLocator(),
        deploymentListener: serviceLocator(),
      )
  );
}
