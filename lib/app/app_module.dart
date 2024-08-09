import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/data/repositories/auth_repository_impl.dart';
import 'package:gatherly/app/data/services/firebase_auth_service.dart';
import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';
import 'package:gatherly/app/domain/usecase/login_usecase.dart';
import 'package:gatherly/app/domain/usecase/register_usecase.dart';
import 'package:gatherly/app/presentation/controllers/create_account/create_account_controller.dart';
import 'package:gatherly/app/presentation/controllers/login/login_controller.dart';
import 'package:gatherly/app/presentation/screens/create_account/create_account_screen.dart';
import 'package:gatherly/app/presentation/screens/login/login_screen.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<AuthService>(AuthService.new);
    i.addLazySingleton<IAuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<LoginUsecase>(LoginUsecase.new);
    i.addLazySingleton<RegisterUsecase>(RegisterUsecase.new);
    i.add<LoginController>(LoginController.new);
    i.add<CreateAccountController>(CreateAccountController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const LoginScreen());
    r.child('/register', child: (context) => CreateAccountScreen());
  }
}
