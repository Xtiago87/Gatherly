import 'package:gatherly/app/data/services/firebase_auth_service.dart';
import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<bool> login(String email, String password) async {
   return await authService.login(email: email, password: password);
  }

  @override
  Future<bool> createAccount(String email, String password) async {
    return await authService.createAccount(email: email, password: password);
  }
}
