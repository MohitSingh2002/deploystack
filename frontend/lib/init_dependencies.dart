import 'package:deploystack/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:deploystack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:deploystack/features/auth/domain/repository/auth_repository.dart';
import 'package:deploystack/features/auth/domain/usecases/user_sign_up.dart';
import 'package:deploystack/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
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

  serviceLocator.registerLazySingleton<AuthBloc>(
      () => AuthBloc(userSignUp: serviceLocator())
  );
}
