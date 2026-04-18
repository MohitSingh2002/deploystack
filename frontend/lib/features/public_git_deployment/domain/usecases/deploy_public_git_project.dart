import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/public_git_deployment/domain/repository/deploy_public_git_project_repo.dart';
import 'package:fpdart/src/either.dart';

class DeployPublicGitProject implements UseCase<bool, DeployPublicGitProjectParams>{
  final DeployPublicGitProjectRepo _deployPublicGitProjectRepo;

  DeployPublicGitProject({required DeployPublicGitProjectRepo deployPublicGitProjectRepo,}) : _deployPublicGitProjectRepo = deployPublicGitProjectRepo;

  @override
  Future<Either<Failure, bool>> call(DeployPublicGitProjectParams params) {
    return _deployPublicGitProjectRepo.deployPublicGitProject(params.cloneUrl);
  }
}

class DeployPublicGitProjectParams {
  final String cloneUrl;

  DeployPublicGitProjectParams({required this.cloneUrl,});
}
