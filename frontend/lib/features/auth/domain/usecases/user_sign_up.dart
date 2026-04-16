import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<bool, UserSignUpParams> {

  final AuthRepository _authRepository;

  UserSignUp({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(UserSignUpParams params) async {
    return await _authRepository.signUp(name: params.name);
  }
}

class UserSignUpParams {
  final String name;

  UserSignUpParams({required this.name,});
}
