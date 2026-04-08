part of 'git_auth_bloc.dart';

@immutable
sealed class GitAuthEvent {}

final class GitAuthConnectEvent extends GitAuthEvent {}
