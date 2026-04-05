import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class CurrentUser implements UseCase<String, NoParams> {
  AuthRepository _authRepository;

  CurrentUser({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _authRepository.currentUser();
  }
}
