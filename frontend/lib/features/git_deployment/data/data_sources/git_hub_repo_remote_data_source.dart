import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:deploystack/features/git_deployment/data/models/git_hub_repo_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class GitHubRepoRemoteDataSource {
  Future<List<GitHubRepoModel>> fetchUserGitHubRepositories();
}

class GitHubRepoRemoteDataSourceImpl implements GitHubRepoRemoteDataSource {
  @override
  Future<List<GitHubRepoModel>> fetchUserGitHubRepositories() async {
    try {
      var res = await http.Client().get(
          Uri.parse('${AppConstants.backendConnectionUrl}/v1/github-repositories'),
          headers: AppConstants.header,
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List repos = decoded['repositories'];

        return repos
            .map((repo) => GitHubRepoModel.fromJson(repo))
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
