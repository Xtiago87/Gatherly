import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';

class RegisterUsecase {
  final IAuthRepository iAuthRepository;

  RegisterUsecase({required this.iAuthRepository});

  Future<bool> createAccount(String email, String password) async {
    return await iAuthRepository.createAccount(email, password);
  }
}