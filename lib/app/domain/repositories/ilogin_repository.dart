abstract class IAuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> createAccount(String email, String password);
}