import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:fpdart/src/either.dart';

class DeployGitRepository implements UseCase<bool, DeployGitRepositoryParams>{
  final GitDeploymentRepository _gitDeploymentRepository;

  DeployGitRepository({required GitDeploymentRepository gitDeploymentRepository,}) : _gitDeploymentRepository = gitDeploymentRepository;

  @override
  Future<Either<Failure, bool>> call(DeployGitRepositoryParams params) {
    return _gitDeploymentRepository.deployGitHubRepo(params.gitHubRepo, params.gitHubRepoBranch,);
  }
}

class DeployGitRepositoryParams {
  final GitHubRepo gitHubRepo;
  final GitHubRepoBranch gitHubRepoBranch;

  DeployGitRepositoryParams({
    required this.gitHubRepo,
    required this.gitHubRepoBranch,
  });
}
