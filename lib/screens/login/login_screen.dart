// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, sort_child_properties_last, unrelated_type_equality_checks

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:flutter/material.dart';

import 'package:akicontrol/widgets/widgets.dart';
import 'package:akicontrol/ui/input_decorations.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = 'Login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Iniciar Sesión',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _LoginForm(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, RegisterScreen.routeName),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      const Color(0xFFE76F51).withOpacity(0.1)),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  )),
              child: const Text(
                'Crear una cuenta',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Campo Correo Electrónico
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'adrian@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Correo electrónico no válido';
            },
          ),

          // Campo Contraseña
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*******',
              labelText: 'Contraseña',
              prefixIcon: Icons.password_rounded,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
          ),

          const SizedBox(height: 30),

          // Boton de Ingresar
          MaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color(0xFFE76F51),
            child: Text(
              loginForm.isLoading ? 'Espere' : 'Iniciar Sesión',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      NotificationsService.showSnackbar(
                          'No hay conexión a Internet');
                      return;
                    }

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    try {
                      final String? errorMessage = await authService.login(
                          loginForm.email, loginForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName);
                      } else {
                        NotificationsService.showSnackbar(errorMessage);
                        loginForm.isLoading = false;
                      }
                    } catch (e) {
                      NotificationsService.showSnackbar(
                          'Ocurrió un error al intentar iniciar sesión. Verifique su conexión a Internet y vuelva a intentarlo.');
                      loginForm.isLoading = false;
                    }
                  },
          ),
        ],
      ),
    );
  }
}
