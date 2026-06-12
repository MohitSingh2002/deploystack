import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/features/custom_domain/data/data_sources/connect_domain_remote_data_source.dart';
import 'package:deploystack/features/custom_domain/domain/repository/connect_domain_repo.dart';
import 'package:fpdart/src/either.dart';

class ConnectDomainRepoImpl implements ConnectDomainRepo {

  ConnectDomainRemoteDataSource _connectDomainRemoteDataSource;

  ConnectDomainRepoImpl({required ConnectDomainRemoteDataSource connectDomainRemoteDataSource}) : _connectDomainRemoteDataSource = connectDomainRemoteDataSource;

  @override
  Future<Either<Failure, void>> connectDomain(String projectId, String domain, String subdomain) async {
    try {
      await _connectDomainRemoteDataSource.connectDomain(projectId, domain, subdomain);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message,));
    }
  }
}
