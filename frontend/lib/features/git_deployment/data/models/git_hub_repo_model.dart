import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';

class GitHubRepoModel extends GitHubRepo {
  GitHubRepoModel({
    required super.fullName,
    required super.cloneUrl,
    required super.ownerName,
    required super.repoName,
    required super.defaultBranch,
  });

  factory GitHubRepoModel.fromJson(Map<String, dynamic> map) {
    return GitHubRepoModel(
      fullName: map['full_name'] ?? '',
      cloneUrl: map['clone_url'] ?? '',
      ownerName: map['owner_name'] ?? '',
      repoName: map['repo_name'] ?? '',
      defaultBranch: map['default_branch'] ?? '',
    );
  }
}
