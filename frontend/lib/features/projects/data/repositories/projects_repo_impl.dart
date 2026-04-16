import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/projects/data/data_sources/projects_remote_data_source.dart';
import 'package:deploystack/features/projects/data/models/project_model.dart';
import 'package:deploystack/features/projects/domain/repository/projects_repo.dart';
import 'package:fpdart/src/either.dart';

class ProjectsRepoImpl implements ProjectsRepo {
  final ProjectsRemoteDataSource _projectsRemoteDataSource;

  ProjectsRepoImpl({required ProjectsRemoteDataSource projectsRemoteDataSource,}) : _projectsRemoteDataSource = projectsRemoteDataSource;

  @override
  Future<Either<Failure, List<ProjectModel>>> fetchAllProjects() async {
    try {
      var res = await _projectsRemoteDataSource.fetchAllProjects();

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
