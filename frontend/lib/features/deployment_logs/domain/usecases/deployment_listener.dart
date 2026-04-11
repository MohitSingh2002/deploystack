import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../repository/deployment_logs_repository.dart';

class DeploymentListener implements UseCase<Stream<dynamic>, NoParams>{
  DeploymentLogsRepository _deploymentLogsRepository;

  DeploymentListener({required DeploymentLogsRepository deploymentLogsRepository,}) : _deploymentLogsRepository = deploymentLogsRepository;

  @override
  Future<Either<Failure, Stream<dynamic>>> call(NoParams params) {
    return _deploymentLogsRepository.deploymentListener();
  }
}
