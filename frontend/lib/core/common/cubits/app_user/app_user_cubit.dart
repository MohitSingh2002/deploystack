import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUsername({required String? username}) {
    if (username == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUser(username: username));
    }
  }
}
