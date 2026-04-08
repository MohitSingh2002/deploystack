part of 'git_authenticated_bloc.dart';

@immutable
sealed class GitAuthenticatedEvent {}

final class IsGitAuthenticatedEvent extends GitAuthenticatedEvent {}

final class GitConnectionSuccessfulEvent extends GitAuthenticatedEvent {}
