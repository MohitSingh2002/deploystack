import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DeployPublicGitProjectRepo {
  Future<Either<Failure, bool>> deployPublicGitProject(String cloneUrl);
}
