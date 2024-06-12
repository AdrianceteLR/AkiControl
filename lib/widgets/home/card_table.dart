// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardTable extends StatelessWidget {
  const CardTable({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return Stack(
      children: [
        Table(
          children: [
            TableRow(children: [
              _SingleCard(
                onPressed: () {
                  Navigator.pushNamed(context, InventoryScreen.routeName);
                },
                iconSingleCard: Icons.border_all,
                colorSingleCard: Colors.blue,
                textSigleCard: 'Inventario',
              ),
              _SingleCard(
                onPressed: () {
                  productsService.selectProduct = Product(
                    available: false,
                    category: 'Otros',
                    name: '',
                    quantity: 0,
                  );
                  Navigator.pushNamed(context, RegisterProduct.routeName);
                },
                iconSingleCard: Icons.playlist_add_check_rounded,
                colorSingleCard: Colors.pink,
                textSigleCard: 'Registro',
              ),
            ]),
            TableRow(children: [
              _SingleCard(
                onPressed: () {
                  Navigator.pushNamed(context, StoreScreen.routeName);
                },
                iconSingleCard: Icons.warehouse_rounded,
                colorSingleCard: Colors.orange,
                textSigleCard: 'Almacenes',
              ),
              _SingleCard(
                onPressed: () {
                  Navigator.pushNamed(context, CalendarScreen.routeName);
                },
                iconSingleCard: Icons.calendar_month_rounded,
                colorSingleCard: Colors.deepPurpleAccent,
                textSigleCard: 'Calendario',
              ),
            ]),
            TableRow(children: [
              _SingleCard(
                onPressed: () {
                  Navigator.pushNamed(context, ReportPdfScreen.routeName);
                },
                iconSingleCard: Icons.picture_as_pdf_rounded,
                colorSingleCard: Colors.blue.shade800,
                textSigleCard: 'Informes',
              ),
              Container(),
            ]),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  _SingleCard({
    required this.textSigleCard,
    required this.iconSingleCard,
    required this.colorSingleCard,
    required this.onPressed,
  });

  final String textSigleCard;
  final IconData iconSingleCard;
  final Color colorSingleCard;
  final VoidCallback onPressed;

  final boxDecoration = BoxDecoration(
      color: const Color.fromARGB(150, 38, 70, 83),
      borderRadius: BorderRadius.circular(30));

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: colorSingleCard,
          radius: 40,
          child: Icon(
            iconSingleCard,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          textSigleCard,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        )
      ],
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 220,
              decoration: boxDecoration,
              child: column,
            ),
          ),
        ),
      ),
    );
  }
}
