import 'package:deploystack/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ConnectDomainRepo {
  Future<Either<Failure, void>> connectDomain(String projectId, String domain, String subdomain);
}
