import 'package:flutter/material.dart';

class ListReport extends StatelessWidget {
  const ListReport({
    super.key,
    required this.name,
    required this.subtitle,
  });

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
