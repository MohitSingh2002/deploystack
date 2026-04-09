class GitHubRepo {
  final String fullName;
  final String cloneUrl;
  final String ownerName;
  final String repoName;
  final String defaultBranch;

  GitHubRepo({
    required this.fullName,
    required this.cloneUrl,
    required this.ownerName,
    required this.repoName,
    required this.defaultBranch,
  });

  @override
  String toString() {
    return 'GitHubRepo{fullName: $fullName, cloneUrl: $cloneUrl, ownerName: $ownerName, repoName: $repoName, defaultBranch: $defaultBranch}';
  }
}
