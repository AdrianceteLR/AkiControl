import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeBackground extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
        0.2,
        0.8
      ],
          colors: [
        Color(0xFF264653),
        Color(0xFF2A9D8F),
      ]));

  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: boxDecoration),
        Positioned(top: -120, left: -20, child: _PinkBox()),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 40.1,
      child: Container(
        width: 470,
        height: 470,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: const LinearGradient(colors: [
              Color(0xFFF4A261),
              Color(0xFFE76F51),
            ])),
      ),
    );
  }
}
