part of 'projects_bloc.dart';

@immutable
sealed class ProjectsState {}

final class ProjectsInitial extends ProjectsState {}

final class ProjectsLoadingState extends ProjectsState {}

final class ProjectsFailureState extends ProjectsState {
  final String message;

  ProjectsFailureState({required this.message,});
}

final class ProjectsSuccessState extends ProjectsState {
  final List<Project> projectList;

  ProjectsSuccessState({required this.projectList,});
}
