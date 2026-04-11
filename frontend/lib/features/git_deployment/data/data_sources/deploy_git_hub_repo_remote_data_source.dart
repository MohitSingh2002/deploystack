import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:deploystack/features/git_deployment/data/models/git_hub_repo_branch_model.dart';
import 'package:deploystack/features/git_deployment/data/models/git_hub_repo_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';

abstract interface class DeployGitHubRepoRemoteDataSource {
  Future<bool> deployGitHubRepo(GitHubRepoModel gitHubRepo, GitHubRepoBranchModel gitHubRepoBranch);
}

class DeployGitHubRepoRemoteDataSourceImpl implements DeployGitHubRepoRemoteDataSource {
  @override
  Future<bool> deployGitHubRepo(GitHubRepoModel gitHubRepo, GitHubRepoBranchModel gitHubRepoBranch) async {
    try {
      var res = await http.Client().post(
          Uri.parse('${AppConstants.backendConnectionUrl}/v1/deploy-git-hub-repo'),
          headers: AppConstants.header,
          body: jsonEncode({
            ...gitHubRepo.toJson(),
            ...gitHubRepoBranch.toJson(),
            'createdAt': DateTime.now().toString(),
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
