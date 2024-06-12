// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  static String routeName = 'Login';

  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _OrangeBox(),
          _HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

// Icono de cabecera
class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, size: 100, color: Colors.white),
      ),
    );
  }
}

// Parte media superior
class _OrangeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _orangeBackground(),
      child: Stack(
        children: [
          Positioned(top: 100, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(bottom: -50, left: 10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble()),
        ],
      ),
    );
  }

  // Color gradiente de arriba
  BoxDecoration _orangeBackground() {
    return const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color(0xFFF4A261),
      Color(0xFFE76F51),
    ]));
  }

  // Burbujas de adorno parte superior
  Container _Bubble() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(43, 255, 255, 255),
      ),
    );
  }
}
