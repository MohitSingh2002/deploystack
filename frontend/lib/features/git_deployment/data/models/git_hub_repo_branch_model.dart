import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';

class GitHubRepoBranchModel extends GitHubRepoBranch {
  GitHubRepoBranchModel({required super.name});

  factory GitHubRepoBranchModel.fromJson(Map<String, dynamic> map) {
    return GitHubRepoBranchModel(
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
