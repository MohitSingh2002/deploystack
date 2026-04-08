import 'package:bloc/bloc.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_auth/domain/usecases/connect_github.dart';
import 'package:meta/meta.dart';

part 'git_auth_event.dart';
part 'git_auth_state.dart';

class GitAuthBloc extends Bloc<GitAuthEvent, GitAuthState> {
  ConnectGithub _connectGithub;

  GitAuthBloc({required ConnectGithub connectGithub}) : _connectGithub = connectGithub, super(GitAuthInitial()) {
    on<GitAuthEvent>((event, emit) {
      emit(GitAuthLoadingState());
    });
    on<GitAuthConnectEvent>(_onGitAuthConnectEvent);
  }

  void _onGitAuthConnectEvent(GitAuthConnectEvent event, Emitter emit) async {
    final res = await _connectGithub.call(NoParams());

    res.fold(
      (failure) {},
      (success) {
        emit(GitAuthConnectionSuccessfulState());
      }
    );
  }
}
