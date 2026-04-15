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

  String get formattedCreatedAt {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final month = months[createdAt.month - 1];
    final day = createdAt.day;
    final year = createdAt.year;

    return '$month $day, $year';
  }

  @override
  String toString() {
    return 'GitHubProject{fullName: $fullName, cloneUrl: $cloneUrl, ownerName: $ownerName, repoName: $repoName, branchName: $branchName, createdAt: ${createdAt.toIso8601String()}}';
  }
}
