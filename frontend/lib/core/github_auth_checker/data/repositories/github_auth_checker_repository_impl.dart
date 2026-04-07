import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/github_auth_checker/data/data_sources/github_auth_checker_remote_data_source.dart';
import 'package:deploystack/core/github_auth_checker/domain/repository/github_auth_checker_repository.dart';
import 'package:fpdart/src/either.dart';

class GithubAuthCheckerRepositoryImpl implements GithubAuthCheckerRepository {
  GithubAuthCheckerRemoteDataSource _githubAuthCheckerRemoteDataSource;

  GithubAuthCheckerRepositoryImpl({required GithubAuthCheckerRemoteDataSource githubAuthCheckerRemoteDataSource}) : _githubAuthCheckerRemoteDataSource = githubAuthCheckerRemoteDataSource;

  @override
  Future<Either<Failure, bool>> checkGitHubAppAvailability() async {
    try {
      bool res = await _githubAuthCheckerRemoteDataSource.checkGitHubAppAvailability();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
