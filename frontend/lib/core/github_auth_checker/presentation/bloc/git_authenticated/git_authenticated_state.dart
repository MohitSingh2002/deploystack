part of 'git_authenticated_bloc.dart';

@immutable
sealed class GitAuthenticatedState {}

final class GitAuthenticatedInitial extends GitAuthenticatedState {}

final class GitAuthenticatedLoadingState extends GitAuthenticatedState {}

final class IsGitAuthenticatedState extends GitAuthenticatedState {
  final bool isAuthenticated;

  IsGitAuthenticatedState({required this.isAuthenticated,});
}
