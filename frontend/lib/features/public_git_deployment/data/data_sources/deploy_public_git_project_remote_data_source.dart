import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class DeployPublicGitProjectRemoteDataSource {
  Future<bool> deployPublicGitProject(String cloneUrl);
}

class DeployPublicGitProjectRemoteDataSourceImpl implements DeployPublicGitProjectRemoteDataSource {
  @override
  Future<bool> deployPublicGitProject(String cloneUrl) async {
    try {
      var res = await http.Client().post(
          Uri.parse('${AppConstants.backendConnectionUrl}/v1/deploy-git-repo'),
          headers: AppConstants.header,
          body: jsonEncode({
            'cloneUrl': cloneUrl,
          })
      );

      return res.statusCode == 201;
    } on ServerException catch (e) {
      throw ServerException(message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
