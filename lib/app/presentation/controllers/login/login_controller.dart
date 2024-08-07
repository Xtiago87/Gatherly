import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/domain/usecase/login_usecase.dart';

class LoginController extends ChangeNotifier {
  final LoginUsecase loginUsecase = Modular.get<LoginUsecase>();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueNotifier<bool> _passwordVis = ValueNotifier(false);
  
  bool get passwordVis => _passwordVis.value;

  void changePasswordVis() {
    _passwordVis.value = !_passwordVis.value;
    notifyListeners();
  }

  void login(String email, String senha) async {
    isLoading.value = true;
    notifyListeners();
    await loginUsecase.login(email, senha);
    Timer(Duration(seconds: 1), () {
      isLoading.value = false;
      notifyListeners();
    });
  }
}
