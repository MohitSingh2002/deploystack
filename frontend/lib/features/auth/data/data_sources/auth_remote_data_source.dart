import 'dart:convert';
import 'package:deploystack/core/error/exceptions.dart';
import 'package:deploystack/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteDataSource {
  Future<bool> signUp({required String name,});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> signUp({required String name}) async {
    try {
      var res = await http.Client().post(
        Uri.parse('${AppConstants.backendConnectionUrl}/api/v1/sign-up'),
        headers: AppConstants.header,
        body: json.encode({
          'name': name,
        })
      );

      if (res.statusCode == 201) {
        return true;
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
