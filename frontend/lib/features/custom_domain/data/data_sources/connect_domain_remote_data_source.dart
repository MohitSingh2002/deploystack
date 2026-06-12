import 'dart:convert';

import 'package:deploystack/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/app_constants.dart';

abstract interface class ConnectDomainRemoteDataSource {
  Future<void> connectDomain(String projectId, String domain, String subdomain);
}

class ConnectDomainRemoteDataSourceImpl implements ConnectDomainRemoteDataSource {

  @override
  Future<void> connectDomain(String projectId, String domain, String subdomain) async {
    try {
      var res = await http.Client().post(
        Uri.parse('${AppConstants.backendConnectionUrl}/v1/connect-domain'),
        headers: AppConstants.header,
        body: jsonEncode({
          'projectId': projectId,
          'domain': domain,
          'subdomain': subdomain,
        }),
      );

      if (res.statusCode == 201) {
        return;
      } else {
        throw ServerException(message: AppConstants.someErrorOccurred);
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

}
