import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/projects/domain/entities/project.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProjectsRepo {
  Future<Either<Failure, List<Project>>> fetchAllProjects();
}
