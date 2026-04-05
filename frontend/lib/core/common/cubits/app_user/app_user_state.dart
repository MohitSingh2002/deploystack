part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUser extends AppUserState {
  final String username;

  AppUser({required this.username,});
}
