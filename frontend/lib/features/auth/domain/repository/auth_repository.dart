import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, bool>> signUp({required String name,});
}
