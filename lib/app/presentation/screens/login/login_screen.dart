import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/presentation/controllers/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Modular.get<LoginController>();
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController senhaTextField = TextEditingController();

  void login() async {
    try {
      await loginController.login(emailTextField.text, senhaTextField.text);
      Modular.to.pushReplacementNamed('/nav_screen');
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success!"), backgroundColor: Colors.green,));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao realizar login"), backgroundColor: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: loginController,
      builder: (context, child) => Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailTextField,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                        controller: senhaTextField,
                        obscureText: loginController.passwordVis,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Digite sua senha...',
                          suffixIcon: loginController.passwordVis
                              ? IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () =>
                                      loginController.changePasswordVis(),
                                )
                              : IconButton(
                                  icon: Icon(Icons.visibility_off),
                                  onPressed: () =>
                                      loginController.changePasswordVis(),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 54,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Login"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Ainda não tem uma conta? ',
                          style: const TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Criar',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Modular.to.pushNamed('/register');
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (loginController.isLoading.value)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (loginController.isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
