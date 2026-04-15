import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:deploystack/features/project_deployment_logs/data/models/project_deployment_log_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class ProjectDeploymentLogRemoteDataSource {
  Future<List<ProjectDeploymentLogModel>> fetchProjectDeploymentLogs(String projectId);
}

class ProjectDeploymentLogRemoteDataSourceImpl implements ProjectDeploymentLogRemoteDataSource {
  @override
  Future<List<ProjectDeploymentLogModel>> fetchProjectDeploymentLogs(String projectId) async {
    try {
      var res = await http.Client().get(
        Uri.parse('${AppConstants.backendConnectionUrl}/v1/project-deployment-logs?project=$projectId'),
        headers: AppConstants.header,
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List logs = decoded['logs'];

        return logs
            .map((log) => ProjectDeploymentLogModel.fromJson(log))
            .toList();
      } else {
        throw ServerException(message: AppConstants.someErrorOccurred);
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
