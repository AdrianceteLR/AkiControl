import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFE76F51),
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: const Color(0xFFE76F51))
          : null,
      suffixIcon: suffixIcon,
    );
  }
}
