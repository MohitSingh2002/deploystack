class GitHubProject {
  final String fullName;
  final String cloneUrl;
  final String ownerName;
  final String repoName;
  final String branchName;
  final DateTime createdAt;

  GitHubProject({
    required this.fullName,
    required this.cloneUrl,
    required this.ownerName,
    required this.repoName,
    required this.branchName,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'GitHubProject{fullName: $fullName, cloneUrl: $cloneUrl, ownerName: $ownerName, repoName: $repoName, branchName: $branchName, createdAt: ${createdAt.toIso8601String()}}';
  }
}
