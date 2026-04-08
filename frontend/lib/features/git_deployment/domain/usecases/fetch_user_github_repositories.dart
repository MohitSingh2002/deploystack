import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/repository/git_deployment_repository.dart';
import 'package:fpdart/src/either.dart';

class FetchUserGithubRepositories implements UseCase<List<GitHubRepo>, NoParams>{
  GitDeploymentRepository _gitDeploymentRepository;

  FetchUserGithubRepositories({required GitDeploymentRepository gitDeploymentRepository}) : _gitDeploymentRepository = gitDeploymentRepository;

  @override
  Future<Either<Failure, List<GitHubRepo>>> call(NoParams params) {
    return _gitDeploymentRepository.fetchUserGitHubRepositories();
  }
}
