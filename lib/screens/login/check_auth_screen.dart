// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:akicontrol/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static String routeName = 'Register';

  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authService.readToken(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Espere');
          }

          if (snapshot.data == '') {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const RegisterScreen(),
                    transitionDuration: const Duration(seconds: 0),
                  ));
            });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionDuration: const Duration(seconds: 0),
                  ));
            });
          }

          return Container();
        }),
      )),
    );
  }
}
