import 'package:deploystack/core/error/failure.dart';
import 'package:deploystack/core/usecase/usecase.dart';
import 'package:deploystack/features/custom_domain/domain/repository/connect_domain_repo.dart';
import 'package:fpdart/src/either.dart';

class ConnectDomainWithProject implements UseCase<void, ConnectDomainWithProjectParam> {

  ConnectDomainRepo _connectDomainRepo;

  ConnectDomainWithProject({required ConnectDomainRepo connectDomainRepo}) : _connectDomainRepo = connectDomainRepo;

  @override
  Future<Either<Failure, void>> call(ConnectDomainWithProjectParam params) async {
    return await _connectDomainRepo.connectDomain(params.projectId, params.domain, params.subdomain);
  }
}

class ConnectDomainWithProjectParam {
  final String projectId;
  final String domain;
  final String subdomain;

  ConnectDomainWithProjectParam({
    required this.projectId,
    required this.domain,
    required this.subdomain,
  });
}
