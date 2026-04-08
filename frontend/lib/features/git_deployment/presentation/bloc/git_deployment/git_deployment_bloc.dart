import 'package:bloc/bloc.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/usecases/fetch_user_github_repositories.dart';
import 'package:meta/meta.dart';

part 'git_deployment_event.dart';
part 'git_deployment_state.dart';

class GitDeploymentBloc extends Bloc<GitDeploymentEvent, GitDeploymentState> {
  FetchUserGithubRepositories _fetchUserGithubRepositories;

  GitDeploymentBloc({required FetchUserGithubRepositories fetchUserGithubRepositories,}) : _fetchUserGithubRepositories = fetchUserGithubRepositories, super(GitDeploymentInitial()) {
    on<GitDeploymentEvent>((event, emit) {
      emit(GitDeploymentLoadingState());
    });
    on<GitDeploymentFetchRepositoriesEvent>(_onGitDeploymentFetchRepositoriesEvent);
  }

  void _onGitDeploymentFetchRepositoriesEvent(GitDeploymentFetchRepositoriesEvent event, Emitter emit) async {
    final res = await _fetchUserGithubRepositories.call(NoParams());

    res.fold(
      (failure) {
        emit(GitDeploymentErrorState(message: failure.message,));
      },
      (success) {
        emit(GitDeploymentSuccessState(gitHubRepoList: success));
      }
    );
  }
}
