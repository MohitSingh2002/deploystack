import 'package:bloc/bloc.dart';
import 'package:deploystack/features/project_deployment_logs/domain/entities/project_deployment_log.dart';
import 'package:deploystack/features/project_deployment_logs/domain/usecases/fetch_project_deployment_logs.dart';
import 'package:meta/meta.dart';

part 'project_deployment_logs_event.dart';
part 'project_deployment_logs_state.dart';

class ProjectDeploymentLogsBloc extends Bloc<ProjectDeploymentLogsEvent, ProjectDeploymentLogsState> {
  final FetchProjectDeploymentLogs _fetchProjectDeploymentLogs;

  ProjectDeploymentLogsBloc({required FetchProjectDeploymentLogs fetchProjectDeploymentLogs}) :
        _fetchProjectDeploymentLogs = fetchProjectDeploymentLogs,
    super(ProjectDeploymentLogsInitial()) {
    on<ProjectDeploymentLogsEvent>((event, emit) {
      emit(ProjectDeploymentLogsLoadingState());
    });
    on<ProjectDeploymentLogsFetchEvent>(_onProjectDeploymentLogsFetchEvent);
  }

  void _onProjectDeploymentLogsFetchEvent(ProjectDeploymentLogsFetchEvent event, Emitter emit) async {
    final res = await _fetchProjectDeploymentLogs.call(FetchProjectDeploymentLogsParams(projectId: event.projectId,));

    res.fold(
      (failure) {
        emit(ProjectDeploymentLogsFailureState(message: failure.message,));
      },
      (success) {
        if (success.isEmpty) {
          emit(ProjectDeploymentNoLogsSuccessState());
        } else {
          emit(ProjectDeploymentLogsSuccessState(projectDeploymentLogList: success,));
        }
      },
    );
  }
}
