// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, sort_child_properties_last, unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/screens/home_screen.dart';
import 'package:akicontrol/screens/login/login_screen.dart';
import 'package:akicontrol/services/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:akicontrol/widgets/widgets.dart';
import 'package:akicontrol/ui/input_decorations.dart';

import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static String routeName = 'Register';

  const RegisterScreen({super.key});

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
                  Text('Crear cuenta',
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
                  context, LoginScreen.routeName),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      const Color(0xFFE76F51).withOpacity(0.1)),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(),
                  )),
              child: const Text(
                '¿Ya tienes una cuenta?',
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
          const SizedBox(height: 20),

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
            onChanged: (value) {
              loginForm.password = value;
              loginForm.notifyListeners();
            },
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
          ),
          const SizedBox(height: 20),

          // Campo Confimación de Contraseña
          Consumer<LoginFormProvider>(
            builder: (context, form, child) => TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.password_rounded,
                suffixIcon: (form.confirmPassword.isNotEmpty &&
                        form.arePasswordMatching())
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              onChanged: (value) {
                loginForm.confirmPassword = value;
                loginForm.notifyListeners();
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value != loginForm.password) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 50),

          // Boton de Ingresar
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color(0xFFE76F51),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Registrar',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    var connectivityResult =
                        await Connectivity().checkConnectivity();
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
                      final String? errorMessage = await authService.createUser(
                          loginForm.email, loginForm.password);

                      if (errorMessage == 'EMAIL_EXISTS') {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title:
                                const Text('Ese correo electrónico ya existe'),
                            content: const Text(
                                'Por favor, utiliza otro correo o inicia sesión si ya tienes una cuenta.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else if (errorMessage == null) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cuenta creada correctamente'),
                            content: const Text(
                                '¡Bienvenido! Tu cuenta ha sido creada.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.routeName);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        NotificationsService.showSnackbar(errorMessage);
                      }
                    } on SocketException {
                      NotificationsService.showSnackbar(
                          'Ocurrió un error al intentar crear una cuenta. Verifique su conexión a Internet y vuelva a intentarlo.');
                    } on TimeoutException {
                      NotificationsService.showSnackbar(
                          'La solicitud ha tardado demasiado tiempo. Intenta de nuevo.');
                    } catch (e) {
                      NotificationsService.showSnackbar(
                          'Ocurrió un error inesperado: $e');
                    } finally {
                      loginForm.isLoading = false;
                    }
                  },
          )
        ],
      ),
    );
  }
}
