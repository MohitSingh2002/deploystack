import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DeploymentLogsRepository {
  Future<Either<Failure, void>> joinDeployment();

  Future<Either<Failure, void>> disconnectDeployment();

  Future<Either<Failure, Stream<dynamic>>> deploymentListener();
}
