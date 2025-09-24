
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';
import '../services/auth_services.dart';
import '../ui/dialogs.dart';
import '../ui/input_decorations.dart';
import '../utils/utils.dart';
import '../widgets/auth_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: Scaffold(
          body: AuthBackground(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
              width: 500,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.35),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(rutaLogo2023, height: 180),
                  ),
                  const SizedBox(height: 40),
                  const Text('Inicio de sesión',
                      textAlign: TextAlign.left,
                      // ignore: unnecessary_const
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _LoginForm(),
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  //String _dropdownvalue = 'App Registro';
  //final _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
              enabled: !loginForm.isLoading,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'guardia', labelText: 'Usuario'),
              onChanged: (value) => loginForm.user = value,
              validator: (value) {
                return (value == null || value.trim().isEmpty)
                    ? 'Ingresa tu usuario'
                    : null;
              }),
          const SizedBox(height: 20),
          TextFormField(
              enabled: !loginForm.isLoading,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'contraseña de usuario', labelText: 'Contraseña'),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value == null || value.trim().isEmpty)
                    ? 'Ingresa tu contraseña'
                    : null;
              }),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
                gradient: loginForm.isLoading
                    ? linearGradientDisabled
                    : linearGradient,
                borderRadius: BorderRadius.circular(15.0)),
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final String? errorMessage = await authService.login(
                          loginForm.user, loginForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        loginForm.isLoading = false;
                        openDialogSimple(
                            context, 'Atención', errorMessage, 'Aceptar');
                      }
                    },
              child: loginForm.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 20, fontFamily: 'PlusJakarta'),
                    ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
