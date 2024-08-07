import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/domain/usecase/register_usecase.dart';

class CreateAccountController extends ChangeNotifier {
  final RegisterUsecase usecase = Modular.get<RegisterUsecase>();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _passwordVis = ValueNotifier(false);
  bool get passwordVis => _passwordVis.value;

  void changePasswordVis() {
    _passwordVis.value = !_passwordVis.value;
    notifyListeners();
  }

  void register(String email, String password) async {
    isLoading.value = true;
    notifyListeners();
    await usecase.createAccount(email, password);
    Timer(Duration(seconds: 1), () {
      isLoading.value = false;
      notifyListeners();
    });
  }
}
