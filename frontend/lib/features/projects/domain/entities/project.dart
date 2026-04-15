import 'package:deploystack/features/projects/domain/entities/git_hub_project.dart';

class Project {
  final String id;
  final String name;
  final String type;
  final String port;
  final GitHubProject? gitHubProject;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.port,
    this.gitHubProject
  });

  @override
  String toString() {
    return 'Project{id: $id, name: $name, type: $type, port: $port, gitHubProject: $gitHubProject}';
  }
}
