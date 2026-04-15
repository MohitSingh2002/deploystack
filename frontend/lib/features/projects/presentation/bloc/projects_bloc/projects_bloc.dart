import 'package:bloc/bloc.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/projects/domain/entities/project.dart';
import 'package:deploystack/features/projects/domain/usecases/fetch_all_projects.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  FetchAllProjects _fetchAllProjects;

  ProjectsBloc({required FetchAllProjects fetchAllProjects}) : _fetchAllProjects = fetchAllProjects, super(ProjectsInitial()) {
    on<ProjectsEvent>((event, emit) {
      emit(ProjectsLoadingState());
    });
    on<ProjectsFetchEvent>(_onProjectsFetchEvent);
  }

  void _onProjectsFetchEvent(ProjectsFetchEvent event, Emitter emit) async {
    final res = await _fetchAllProjects.call(NoParams());

    res.fold(
      (failure) {
        emit(ProjectsFailureState(message: failure.message,));
      },
      (success) {
        emit(ProjectsSuccessState(projectList: success,));
      }
    );
  }
}
