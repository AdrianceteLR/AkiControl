import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AkiControl',
                style: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(
              'Una aplicación de gestión de inventarios diseñada para ayudar a las empresas a administrar y rastrear sus productos de manera eficiente.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
