import 'package:bloc/bloc.dart';
import 'package:deploystack/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:deploystack/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  UserSignUp _userSignUp;
  AppUserCubit _appUserCubit;

  AuthBloc({required UserSignUp userSignUp, required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
      _appUserCubit = appUserCubit,
  super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<AuthSignUp>(_onAuthSignUp);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(UserSignUpParams(name: event.name));

    res.fold(
        (failure) {
          print(failure.message);
          emit(AuthFailure(message: failure.message));
        },
        (success) {
          _appUserCubit.updateUsername(username: event.name);
          emit(AuthSuccess());
        }
    );
  }
}
