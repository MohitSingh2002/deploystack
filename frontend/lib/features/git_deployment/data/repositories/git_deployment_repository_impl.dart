import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:fpdart/src/either.dart';

class GitDeploymentRepositoryImpl implements GitDeploymentRepository {
  GitHubRepoRemoteDataSource _gitHubRepoRemoteDataSource;

  GitDeploymentRepositoryImpl({required GitHubRepoRemoteDataSource gitHubRepoRemoteDataSource,}) : _gitHubRepoRemoteDataSource = gitHubRepoRemoteDataSource;

  @override
  Future<Either<Failure, List<GitHubRepo>>> fetchUserGitHubRepositories() async {
    try {
      final res = await _gitHubRepoRemoteDataSource.fetchUserGitHubRepositories();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
