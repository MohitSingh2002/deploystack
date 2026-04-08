import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_constants.dart';
import 'dart:html' as html;

abstract interface class GitAuthRemoteDataSource {
  Future<void> connectGithub();
}

class GitAuthRemoteDataSourceImpl implements GitAuthRemoteDataSource {
  @override
  Future<void> connectGithub() async {
    html.window.location.href = '${AppConstants.backendConnectionUrl}/v1/git-auth';

    // try {
    //   var res = await http.Client().get(
    //       Uri.parse('${AppConstants.backendConnectionUrl}/v1/git-auth'),
    //       headers: AppConstants.header,
    //   );
    //
    //   print(res.body);
    //
    //   if (res.statusCode == 200) {
    //     return;
    //   } else {
    //     throw ServerException(message: AppConstants.someErrorOccurred);
    //   }
    // } on ServerException catch (e) {
    //   throw ServerException(message: e.toString());
    // } catch (e) {
    //   throw ServerException(message: e.toString());
    // }
  }
}
