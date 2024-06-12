import 'package:flutter/material.dart';

Future<dynamic> dialogs(
  BuildContext context, {
  required String title,
  Color? color,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: color ?? const Color.fromARGB(255, 107, 199, 188),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}
