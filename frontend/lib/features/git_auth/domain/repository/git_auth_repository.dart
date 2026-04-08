import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GitAuthRepository {
  Future<Either<Failure, void>> connectGithub();
}
