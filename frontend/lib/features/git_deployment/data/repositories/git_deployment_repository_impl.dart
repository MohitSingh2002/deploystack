import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/deploy_git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/git_hub_repo_branch_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/data/data_sources/git_hub_repo_remote_data_source.dart';
import 'package:deploystack/features/git_deployment/data/models/git_hub_repo_model.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:fpdart/src/either.dart';

import '../../domain/entities/git_hub_repo.dart';
import '../../domain/entities/git_hub_repo_branch.dart';
import '../models/git_hub_repo_branch_model.dart';

class GitDeploymentRepositoryImpl implements GitDeploymentRepository {
  final GitHubRepoRemoteDataSource _gitHubRepoRemoteDataSource;
  final GitHubRepoBranchRemoteDataSource _gitHubRepoBranchRemoteDataSource;
  final DeployGitHubRepoRemoteDataSource _deployGitHubRepoRemoteDataSource;

  GitDeploymentRepositoryImpl({
    required GitHubRepoRemoteDataSource gitHubRepoRemoteDataSource,
    required GitHubRepoBranchRemoteDataSource gitHubRepoBranchRemoteDataSource,
    required DeployGitHubRepoRemoteDataSource deployGitHubRepoRemoteDataSource,
  })
  : _gitHubRepoRemoteDataSource = gitHubRepoRemoteDataSource,
    _gitHubRepoBranchRemoteDataSource = gitHubRepoBranchRemoteDataSource,
    _deployGitHubRepoRemoteDataSource = deployGitHubRepoRemoteDataSource
  ;

  @override
  Future<Either<Failure, List<GitHubRepoModel>>> fetchUserGitHubRepositories() async {
    try {
      final res = await _gitHubRepoRemoteDataSource.fetchUserGitHubRepositories();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }

  @override
  Future<Either<Failure, List<GitHubRepoBranchModel>>> fetchGitHubRepositoryBranches(String owner, String repo) async {
    try {
      final res = await _gitHubRepoBranchRemoteDataSource.fetchGitHubRepositoryBranches(owner, repo);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }

  @override
  Future<Either<Failure, bool>> deployGitHubRepo(GitHubRepo gitHubRepo, GitHubRepoBranch gitHubRepoBranch) async {
    try {
      final res = await _deployGitHubRepoRemoteDataSource.deployGitHubRepo(gitHubRepo as GitHubRepoModel, gitHubRepoBranch as GitHubRepoBranchModel);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
