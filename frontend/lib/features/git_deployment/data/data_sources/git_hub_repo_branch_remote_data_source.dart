import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:deploystack/features/git_deployment/data/models/git_hub_repo_branch_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class GitHubRepoBranchRemoteDataSource {
  Future<List<GitHubRepoBranchModel>> fetchGitHubRepositoryBranches(String owner, String repo);
}

class GitHubRepoBranchRemoteDataSourceImpl implements GitHubRepoBranchRemoteDataSource {
  @override
  Future<List<GitHubRepoBranchModel>> fetchGitHubRepositoryBranches(String owner, String repo) async {
    try {
      var res = await http.Client().get(
        Uri.parse('${AppConstants.backendConnectionUrl}/v1/github-branches?owner=$owner&repo=$repo'),
        headers: AppConstants.header,
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List repos = decoded['branches'];

        return repos
            .map((repo) => GitHubRepoBranchModel.fromJson(repo))
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
