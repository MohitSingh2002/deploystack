import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';

class GitHubRepoModel extends GitHubRepo {
  GitHubRepoModel({required super.fullName, required super.cloneUrl,});

  factory GitHubRepoModel.fromJson(Map<String, dynamic> map) {
    return GitHubRepoModel(
      fullName: map['full_name'] ?? '',
      cloneUrl: map['clone_url'] ?? '',
    );
  }
}
