import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GitDeploymentRepository {
  Future<Either<Failure, List<GitHubRepo>>> fetchUserGitHubRepositories();

  Future<Either<Failure, List<GitHubRepoBranch>>> fetchGitHubRepositoryBranches(String owner, String repo);
}
