import 'package:bloc/bloc.dart';
import 'package:deploystack/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  UserSignUp _userSignUp;

  AuthBloc({required UserSignUp userSignUp}) : _userSignUp = userSignUp, super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<AuthSignUp>(_onAuthSignUp);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(UserSignUpParams(name: event.name));

    res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (success) => emit(AuthSuccess())
    );
  }
}
