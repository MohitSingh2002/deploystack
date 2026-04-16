import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/git_auth/data/data_sources/git_auth_remote_data_source.dart';
import 'package:deploystack/features/git_auth/domain/repository/git_auth_repository.dart';
import 'package:fpdart/src/either.dart';

class GitAuthRepositoryImpl implements GitAuthRepository {
  final GitAuthRemoteDataSource _gitAuthRemoteDataSource;

  GitAuthRepositoryImpl({required GitAuthRemoteDataSource gitAuthRemoteDataSource,}) : _gitAuthRemoteDataSource = gitAuthRemoteDataSource;

  @override
  Future<Either<Failure, void>> connectGithub() async {
    try {
      await _gitAuthRemoteDataSource.connectGithub();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
