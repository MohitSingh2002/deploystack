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
    return 'GitHubProject{fullName: $fullName, cloneUrl: $cloneUrl, ownerName: $ownerName, repoName: $repoName, branchName: $branchName, createdAt: ${createdAt.toIso8601String()}}';
  }
}
