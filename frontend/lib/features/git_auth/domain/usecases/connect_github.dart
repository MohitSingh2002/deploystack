import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_auth/domain/repository/git_auth_repository.dart';
import 'package:fpdart/src/either.dart';

class ConnectGithub implements UseCase<void, NoParams> {
  GitAuthRepository _gitAuthRepository;

  ConnectGithub({required GitAuthRepository gitAuthRepository,}) : _gitAuthRepository = gitAuthRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _gitAuthRepository.connectGithub();
  }
}
