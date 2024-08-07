import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';

class AuthRepositoryImpl implements IAuthRepository{
  @override
  Future<void> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> createAccount(String email, String password) {
    throw UnimplementedError();
  }

}