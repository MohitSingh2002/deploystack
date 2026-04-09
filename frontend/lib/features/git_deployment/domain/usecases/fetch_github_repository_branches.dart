import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:fpdart/src/either.dart';

class FetchGithubRepositoryBranches implements UseCase<List<GitHubRepoBranch>, GitHubRepoBranchUseCaseParams> {
  final GitDeploymentRepository _gitDeploymentRepository;

  FetchGithubRepositoryBranches({required GitDeploymentRepository gitDeploymentRepository}) : _gitDeploymentRepository = gitDeploymentRepository;

  @override
  Future<Either<Failure, List<GitHubRepoBranch>>> call(GitHubRepoBranchUseCaseParams params) async {
    return await _gitDeploymentRepository.fetchGitHubRepositoryBranches(params.owner, params.repo);
  }
}

class GitHubRepoBranchUseCaseParams {
  final String owner;
  final String repo;

  GitHubRepoBranchUseCaseParams({
    required this.owner,
    required this.repo,
  });
}
