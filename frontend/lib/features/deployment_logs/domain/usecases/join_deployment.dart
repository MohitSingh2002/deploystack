import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/deployment_logs/domain/repository/deployment_logs_repository.dart';
import 'package:fpdart/src/either.dart';

class JoinDeployment implements UseCase<void, NoParams> {
  DeploymentLogsRepository _deploymentLogsRepository;

  JoinDeployment({required DeploymentLogsRepository deploymentLogsRepository,}) : _deploymentLogsRepository = deploymentLogsRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _deploymentLogsRepository.joinDeployment();
  }
}
