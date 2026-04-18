import 'package:deploystack/features/projects/domain/entities/git_hub_project.dart';

class Project {
  final String id;
  final String name;
  final String type;
  final String port;
  final DateTime createdAt;
  final GitHubProject? gitHubProject;

  Project({
    required this.id,
    required this.name,
    required this.type,
    required this.port,
    required this.createdAt,
    this.gitHubProject
  });

  String get formattedCreatedAt {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final month = months[createdAt.month - 1];
    final day = createdAt.day;
    final year = createdAt.year;

    int hour = createdAt.hour;
    final minute = createdAt.minute;

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$month $day, $year at $hour:$formattedMinute $period';
  }

  @override
  String toString() {
    return 'Project{id: $id, name: $name, type: $type, port: $port, createdAt: $createdAt, gitHubProject: $gitHubProject}';
  }
}
