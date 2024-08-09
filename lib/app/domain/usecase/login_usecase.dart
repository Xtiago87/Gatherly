import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';

class LoginUsecase {
  final IAuthRepository iAuthRepository;

  LoginUsecase({required this.iAuthRepository});

  Future<bool> login(String email, String password) async {
    return await iAuthRepository.login(email, password);
  }
}