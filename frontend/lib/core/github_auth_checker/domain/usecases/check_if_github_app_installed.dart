import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/github_auth_checker/domain/repository/github_auth_checker_repository.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class CheckIfGithubAppInstalled implements UseCase<bool, NoParams> {
  final GithubAuthCheckerRepository _githubAuthCheckerRepository;

  CheckIfGithubAppInstalled({required GithubAuthCheckerRepository githubAuthCheckerRepository}) : _githubAuthCheckerRepository = githubAuthCheckerRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _githubAuthCheckerRepository.checkGitHubAppAvailability();
  }
}
