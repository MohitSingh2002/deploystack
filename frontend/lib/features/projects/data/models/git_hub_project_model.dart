import 'package:deploystack/features/projects/domain/entities/git_hub_project.dart';

class GitHubProjectModel extends GitHubProject {
  GitHubProjectModel({required super.fullName, required super.cloneUrl, required super.ownerName, required super.repoName, required super.branchName, required super.createdAt});

  factory GitHubProjectModel.fromJson(Map<String, dynamic> map) {
    return GitHubProjectModel(
      fullName: map['fullName'] ?? '',
      cloneUrl: map['cloneUrl'] ?? '',
      ownerName: map['ownerName'] ?? '',
      repoName: map['repoName'] ?? '',
      branchName: map['branchName'] ?? '',
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
