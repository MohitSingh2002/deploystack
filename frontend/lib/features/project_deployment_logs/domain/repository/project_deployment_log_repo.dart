import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/project_deployment_logs/domain/entities/project_deployment_log.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProjectDeploymentLogRepo {
  Future<Either<Failure, List<ProjectDeploymentLog>>> fetchProjectDeploymentLogs(String projectId);
}
