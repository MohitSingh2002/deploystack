import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/deployment_logs/data/data_sources/deployment_socket_remote_data_source.dart';
import 'package:deploystack/features/deployment_logs/domain/repository/deployment_logs_repository.dart';
import 'package:fpdart/src/either.dart';

class DeploymentLogsRepositoryImpl implements DeploymentLogsRepository {
  DeploymentSocketRemoteDataSource _deploymentSocketRemoteDataSource;

  DeploymentLogsRepositoryImpl({required DeploymentSocketRemoteDataSource deploymentSocketRemoteDataSource,}) : _deploymentSocketRemoteDataSource = deploymentSocketRemoteDataSource;

  @override
  Future<Either<Failure, void>> joinDeployment() async {
    try {
      await _deploymentSocketRemoteDataSource.joinDeployment();

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectDeployment() async {
    try {
      await _deploymentSocketRemoteDataSource.disconnectDeployment();

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }

  @override
  Future<Either<Failure, Stream<dynamic>>> deploymentListener() async {
    try {
      final res = _deploymentSocketRemoteDataSource.deploymentListener();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
