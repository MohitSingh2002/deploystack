class ProjectDeploymentLog {
  final String log;
  final DateTime createdAt;

  ProjectDeploymentLog({
    required this.log,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'ProjectDeploymentLog{log: $log, createdAt: $createdAt}';
  }
}
