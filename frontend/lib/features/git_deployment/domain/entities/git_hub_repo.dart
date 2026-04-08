class GitHubRepo {
  final String fullName;
  final String cloneUrl;

  GitHubRepo({
    required this.fullName,
    required this.cloneUrl,
  });

  @override
  String toString() {
    return 'GitHubRepo{fullName: $fullName, cloneUrl: $cloneUrl}';
  }
}
