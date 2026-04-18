import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/deploy_git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/public_git_deployment/data/data_sources/deploy_public_git_project_remote_data_source.dart';
import 'package:deploystack/features/public_git_deployment/domain/repository/deploy_public_git_project_repo.dart';
import 'package:fpdart/src/either.dart';

class DeployPublicGitProjectRepoImpl implements DeployPublicGitProjectRepo {
  final DeployPublicGitProjectRemoteDataSource _deployPublicGitProjectRemoteDataSource;

  DeployPublicGitProjectRepoImpl({required DeployPublicGitProjectRemoteDataSource deployPublicGitProjectRemoteDataSource}) : _deployPublicGitProjectRemoteDataSource = deployPublicGitProjectRemoteDataSource;

  @override
  Future<Either<Failure, bool>> deployPublicGitProject(String cloneUrl) async {
    try {
      final res = await _deployPublicGitProjectRemoteDataSource.deployPublicGitProject(cloneUrl);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
