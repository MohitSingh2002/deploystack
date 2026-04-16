import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/project_deployment_logs/domain/entities/project_deployment_log.dart';
import 'package:deploystack/features/project_deployment_logs/domain/repository/project_deployment_log_repo.dart';
import 'package:fpdart/src/either.dart';

class FetchProjectDeploymentLogs implements UseCase<List<ProjectDeploymentLog>, FetchProjectDeploymentLogsParams>{
  final ProjectDeploymentLogRepo _projectDeploymentLogRepo;

  FetchProjectDeploymentLogs({required ProjectDeploymentLogRepo projectDeploymentLogRepo}) : _projectDeploymentLogRepo = projectDeploymentLogRepo;

  @override
  Future<Either<Failure, List<ProjectDeploymentLog>>> call(FetchProjectDeploymentLogsParams params) {
    return _projectDeploymentLogRepo.fetchProjectDeploymentLogs(params.projectId);
  }
}

class FetchProjectDeploymentLogsParams {
  final String projectId;

  FetchProjectDeploymentLogsParams({required this.projectId,});
}
