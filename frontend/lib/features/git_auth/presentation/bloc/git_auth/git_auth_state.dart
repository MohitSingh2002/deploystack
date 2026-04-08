part of 'git_auth_bloc.dart';

@immutable
sealed class GitAuthState {}

final class GitAuthInitial extends GitAuthState {}

final class GitAuthLoadingState extends GitAuthState {}

final class GitAuthConnectionSuccessfulState extends GitAuthState {}
