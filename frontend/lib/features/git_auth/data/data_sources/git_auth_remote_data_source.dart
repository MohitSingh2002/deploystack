import '../../../../core/utils/app_constants.dart';
import 'dart:html' as html;

abstract interface class GitAuthRemoteDataSource {
  Future<void> connectGithub();
}

class GitAuthRemoteDataSourceImpl implements GitAuthRemoteDataSource {
  @override
  Future<void> connectGithub() async {
    html.window.location.href = '${AppConstants.backendConnectionUrl}/v1/git-auth';
  }
}
