// ignore_for_file: camel_case_types, depend_on_referenced_packages

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final productsService = Provider.of<ProductsService>(context);

    return Column(
      children: [
        _menuDrawerOptions(
          icon: const Icon(Icons.home_rounded),
          text: const Text('Home'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.border_all),
          text: const Text('Inventario'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, InventoryScreen.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.playlist_add_check_rounded),
          text: const Text('Registro'),
          onTapFunction: () {
            authService.logout();
            productsService.selectProduct = Product(
              available: false,
              category: 'Otros',
              name: '',
              quantity: 0,
            );
            Navigator.pushNamed(context, RegisterProduct.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.warehouse_rounded),
          text: const Text('Almacenes'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, StoreScreen.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.calendar_month_rounded),
          text: const Text('Calendario'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, CalendarScreen.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.picture_as_pdf_rounded),
          text: const Text('Informes'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, ReportPdfScreen.routeName);
          },
        ),
        const Divider(),
        _menuDrawerOptions(
          icon: const Icon(Icons.exit_to_app_rounded),
          text: const Text('Cerrar Sesión'),
          onTapFunction: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
        ),
      ],
    );
  }
}

class _menuDrawerOptions extends StatelessWidget {
  final Icon icon;
  final Text text;
  final Function? onTapFunction;

  const _menuDrawerOptions({
    required this.icon,
    required this.text,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: text,
      onTap: onTapFunction as void Function()?,
    );
  }
}
