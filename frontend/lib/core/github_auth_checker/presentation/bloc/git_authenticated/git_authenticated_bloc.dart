import 'package:bloc/bloc.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/github_auth_checker/domain/usecases/check_if_github_app_installed.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'git_authenticated_event.dart';
part 'git_authenticated_state.dart';

class GitAuthenticatedBloc extends Bloc<GitAuthenticatedEvent, GitAuthenticatedState> {
  final CheckIfGithubAppInstalled _checkIfGithubAppInstalled;

  GitAuthenticatedBloc({required CheckIfGithubAppInstalled checkIfGithubAppInstalled}) : _checkIfGithubAppInstalled = checkIfGithubAppInstalled,
  super(GitAuthenticatedInitial()) {
    on<GitAuthenticatedEvent>((event, emit) {
      emit(GitAuthenticatedLoadingState());
    });
    on<IsGitAuthenticatedEvent>(_onIsGitAuthenticated);
    on<GitConnectionSuccessfulEvent>(_onGitConnectionSuccessful);
  }

  void _onIsGitAuthenticated(IsGitAuthenticatedEvent event, Emitter emit) async {
    Either<Failure, bool> res = await _checkIfGithubAppInstalled.call(NoParams());

    res.fold(
      (failure) {
        emit(IsGitAuthenticatedState(isAuthenticated: false));
      },
      (success) {
        emit(IsGitAuthenticatedState(isAuthenticated: success));
      }
    );
  }

  void _onGitConnectionSuccessful(GitConnectionSuccessfulEvent event, Emitter emit) {
    emit(IsGitAuthenticatedState(isAuthenticated: true));
  }
}
