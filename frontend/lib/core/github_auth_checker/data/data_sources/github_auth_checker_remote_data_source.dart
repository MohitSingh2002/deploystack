import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../error/exceptions.dart';
import '../../../utils/app_constants.dart';

abstract interface class GithubAuthCheckerRemoteDataSource {
  Future<bool> checkGitHubAppAvailability();
}

class GithubAuthCheckerRemoteDataSourceImpl implements GithubAuthCheckerRemoteDataSource {
  @override
  Future<bool> checkGitHubAppAvailability() async {
    try {
      var res = await http.Client().get(
          Uri.parse('${AppConstants.backendConnectionUrl}/check-app'),
          headers: AppConstants.header,
      );

      if (res.statusCode == 200) {
        return json.decode(res.body)['isInstalled'];
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
