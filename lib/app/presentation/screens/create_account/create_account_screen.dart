import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/presentation/controllers/create_account/create_account_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController cEmailTextField = TextEditingController();
  final TextEditingController senhaTextField = TextEditingController();
  final TextEditingController cSenhaTextField = TextEditingController();
  final CreateAccountController createAccountController =
      Modular.get<CreateAccountController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: createAccountController,
      builder: (context, child) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text("Criar conta")),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        TextFormField(
                          controller: emailTextField,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo não pode estar vazio.';
                            }
                            if (value != cEmailTextField.text) {
                              return "Os emails não coincidem.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Digite seu email...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: cEmailTextField,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo não pode estar vazio.';
                            }
                            if (value != emailTextField.text) {
                              return "Os emails senhas não coincidem.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmar Email',
                            hintText: 'Digite seu email...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: senhaTextField,
                          obscureText: createAccountController.passwordVis,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo não pode estar vazio.';
                            }
                            if (value != cSenhaTextField.text) {
                              return "As senhas não coincidem.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            hintText: 'Digite sua senha...',
                            suffixIcon: createAccountController.passwordVis
                                ? IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () => createAccountController
                                        .changePasswordVis(),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.visibility_off),
                                    onPressed: () => createAccountController
                                        .changePasswordVis(),
                                  ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: cSenhaTextField,
                          textInputAction: TextInputAction.next,
                          obscureText: createAccountController.passwordVis,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo não pode estar vazio.';
                            }
                            if (value != senhaTextField.text) {
                              return "As senhas não coincidem.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            hintText: 'Digite sua senha...',
                            suffixIcon: createAccountController.passwordVis
                                ? IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () => createAccountController
                                        .changePasswordVis(),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.visibility_off),
                                    onPressed: () => createAccountController
                                        .changePasswordVis(),
                                  ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                createAccountController.register(
                                    emailTextField.text, senhaTextField.text);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Criar conta!"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (createAccountController.isLoading.value)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (createAccountController.isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
