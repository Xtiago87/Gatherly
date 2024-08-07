abstract class IAuthRepository {
  Future<void> login(String email, String password);
  Future<void> createAccount(String email, String password);
}