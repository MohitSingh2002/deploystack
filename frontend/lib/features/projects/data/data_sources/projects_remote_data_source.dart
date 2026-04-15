import 'dart:convert';

import 'package:deploystack/features/projects/data/models/project_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class ProjectsRemoteDataSource {
  Future<List<ProjectModel>> fetchAllProjects();
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  @override
  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      var res = await http.Client().get(
        Uri.parse('${AppConstants.backendConnectionUrl}/v1/projects'),
        headers: AppConstants.header,
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List projects = decoded['projects'];

        return projects
            .map((project) => ProjectModel.fromJson(project))
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
