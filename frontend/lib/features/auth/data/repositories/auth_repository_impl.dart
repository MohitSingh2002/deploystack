import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:deploystack/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class AuthRepositoryImpl implements AuthRepository {

  AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource}) : _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<Either<Failure, bool>> signUp({required String name}) async {
    try {
      bool res = await _authRemoteDataSource.signUp(name: name,);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> currentUser() async {
    try {
      String res = await _authRemoteDataSource.currentUser();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
