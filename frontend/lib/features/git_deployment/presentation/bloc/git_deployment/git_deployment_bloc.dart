import 'package:bloc/bloc.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo.dart';
import 'package:deploystack/features/git_deployment/domain/entities/git_hub_repo_branch.dart';
import 'package:deploystack/features/git_deployment/domain/usecases/fetch_github_repository_branches.dart';
import 'package:deploystack/features/git_deployment/domain/usecases/fetch_user_github_repositories.dart';
import 'package:meta/meta.dart';

part 'git_deployment_event.dart';
part 'git_deployment_state.dart';

class GitDeploymentBloc extends Bloc<GitDeploymentEvent, GitDeploymentState> {
  final FetchUserGithubRepositories _fetchUserGithubRepositories;
  final FetchGithubRepositoryBranches _fetchGithubRepositoryBranches;

  GitDeploymentBloc({
    required FetchUserGithubRepositories fetchUserGithubRepositories,
    required FetchGithubRepositoryBranches fetchGithubRepositoryBranches
  })
      : _fetchUserGithubRepositories = fetchUserGithubRepositories,
        _fetchGithubRepositoryBranches = fetchGithubRepositoryBranches,
        super(GitDeploymentInitial()) {
    on<GitDeploymentEvent>((event, emit) {
      // emit(GitDeploymentLoadingState());
    });
    on<GitDeploymentFetchRepositoriesEvent>(_onGitDeploymentFetchRepositoriesEvent);
    on<GitDeploymentFetchRepositoryBranchesEvent>(_onGitDeploymentFetchRepositoryBranchesEvent);
  }

  void _onGitDeploymentFetchRepositoriesEvent(GitDeploymentFetchRepositoriesEvent event, Emitter emit) async {
    emit(GitDeploymentLoadingState());
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

  void _onGitDeploymentFetchRepositoryBranchesEvent(GitDeploymentFetchRepositoryBranchesEvent event, Emitter emit) async {
    final currentState = state;
    if (currentState is GitDeploymentSuccessState) {
      emit(currentState.copyWith(isFetchingBranches: true));
    }

    final res = await _fetchGithubRepositoryBranches.call(GitHubRepoBranchUseCaseParams(owner: event.gitHubRepo.ownerName, repo: event.gitHubRepo.repoName));

    res.fold(
      (failure) {
        emit(GitDeploymentErrorState(message: failure.message,));
      },
      (success) {
        emit(GitDeploymentSuccessState(gitHubRepoList: (currentState is GitDeploymentSuccessState) ? currentState.gitHubRepoList : [], defaultBranchName: event.gitHubRepo.defaultBranch, gitHubRepoBranchList: success));
      }
    );
  }
}
