import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/projects/domain/entities/project.dart';
import 'package:deploystack/features/projects/domain/repository/projects_repo.dart';
import 'package:fpdart/src/either.dart';

class FetchAllProjects implements UseCase<List<Project>, NoParams> {
  final ProjectsRepo _projectsRepo;

  FetchAllProjects({required ProjectsRepo projectsRepo,}) : _projectsRepo = projectsRepo;

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) {
    return _projectsRepo.fetchAllProjects();
  }
}
