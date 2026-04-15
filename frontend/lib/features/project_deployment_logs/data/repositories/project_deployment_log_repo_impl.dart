import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/project_deployment_logs/data/data_sources/project_deployment_log_remote_data_source.dart';
import 'package:deploystack/features/project_deployment_logs/domain/entities/project_deployment_log.dart';
import 'package:deploystack/features/project_deployment_logs/domain/repository/project_deployment_log_repo.dart';
import 'package:fpdart/src/either.dart';

class ProjectDeploymentLogRepoImpl implements ProjectDeploymentLogRepo {
  final ProjectDeploymentLogRemoteDataSource _projectDeploymentLogRemoteDataSource;

  ProjectDeploymentLogRepoImpl({required ProjectDeploymentLogRemoteDataSource projectDeploymentLogRemoteDataSource}) : _projectDeploymentLogRemoteDataSource = projectDeploymentLogRemoteDataSource;

  @override
  Future<Either<Failure, List<ProjectDeploymentLog>>> fetchProjectDeploymentLogs(String projectId) async {
    try {
      var res = await _projectDeploymentLogRemoteDataSource.fetchProjectDeploymentLogs(projectId);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
