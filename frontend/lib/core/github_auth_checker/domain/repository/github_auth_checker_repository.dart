import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GithubAuthCheckerRepository {
  Future<Either<Failure, bool>> checkGitHubAppAvailability();
}
