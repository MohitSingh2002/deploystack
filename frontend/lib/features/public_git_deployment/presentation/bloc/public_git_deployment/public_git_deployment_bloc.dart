import 'package:bloc/bloc.dart';
import 'package:deploystack/features/public_git_deployment/domain/usecases/deploy_public_git_project.dart';
import 'package:meta/meta.dart';

part 'public_git_deployment_event.dart';
part 'public_git_deployment_state.dart';

class PublicGitDeploymentBloc extends Bloc<PublicGitDeploymentEvent, PublicGitDeploymentState> {
  final DeployPublicGitProject _deployPublicGitProject;

  PublicGitDeploymentBloc({required DeployPublicGitProject deployPublicGitProject,}) : _deployPublicGitProject = deployPublicGitProject, super(PublicGitDeploymentInitial()) {
    on<PublicGitDeploymentEvent>((event, emit) {
      emit(PublicGitDeploymentLoadingState());
    });
    on<DeployGitProjectEvent>(_onDeployGitProjectEvent);
  }

  void _onDeployGitProjectEvent(DeployGitProjectEvent event, Emitter emit) async {
    final res = await _deployPublicGitProject.call(DeployPublicGitProjectParams(cloneUrl: event.cloneUrl,));

    res.fold(
        (failure) {
          emit(PublicGitDeploymentErrorState(message: failure.message,));
        },
        (success) {
          emit(PublicGitDeploymentSuccessState());
        },
    );
  }
}
