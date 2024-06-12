// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productService.selectProduct),
      child: _HomeScreen(productsService: productService),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({
    required this.productsService,
  });

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
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
          // Background
          const HomeBackground(),

          // Home Body
          _HomeBody(),
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

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // Title
          PageTitle(),

          // Card Tabla
          CardTable(),
        ],
      ),
    );
  }
}
