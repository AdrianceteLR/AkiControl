// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  static String routeName = 'Inventory';

  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      drawer: Drawer(
          backgroundColor: const Color(0xFFFFF5EE),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_headerDrawer(context), const MenuDrawer()],
            ),
          )),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const HomeBackground(),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Numero de columnas
                crossAxisSpacing: 0, // Espaciado entre columnas
                mainAxisSpacing: 0, // Espaciado entre filas
                childAspectRatio: 1.2,
              ),
              itemCount: productsService.products.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  productsService.selectProduct =
                      productsService.products[index].copy();
                  Navigator.pushNamed(
                      context, ProductInventoryScreen.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: ListProductCard(
                    product: productsService.products[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Material _headerDrawer(BuildContext context) {
    return Material(
      color: const Color(0xFFE76F51),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: 25),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                'AkiControl',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
