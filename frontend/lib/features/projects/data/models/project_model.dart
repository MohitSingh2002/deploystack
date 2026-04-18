import 'package:deploystack/features/projects/data/models/git_hub_project_model.dart';
import 'package:deploystack/features/projects/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({required super.id, required super.name, required super.type, required super.port, required super.createdAt, super.gitHubProject,});

  factory ProjectModel.fromJson(Map<String, dynamic> map) {
    GitHubProjectModel? gitHubProjectModel;

    if (map['type'] == 'git-repo-deployment') {
      gitHubProjectModel = GitHubProjectModel.fromJson(map['gitHubProject']);
    }

    ProjectModel model = ProjectModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      port: map['port'] ?? '',
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      gitHubProject: gitHubProjectModel
    );

    return model;
  }
}
