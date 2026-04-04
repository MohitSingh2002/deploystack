abstract interface class AuthRemoteDataSource {
  Future<bool> signUp({required String name,});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> signUp({required String name}) async {
    // TODO : Integrate Registration API Here.
    await Future.delayed(Duration(seconds: 5));
    return true;
  }
}
