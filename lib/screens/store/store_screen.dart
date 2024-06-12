// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  static String routeName = 'Store';

  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storesService = Provider.of<StoresService>(context);

    if (storesService.isLoading) return const LoadingScreen();

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
          SafeArea(
            child: Column(
              children: [
                const Text(
                  'Listado de almacenes',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 3,
                  indent: 20,
                  endIndent: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemCount: storesService.stores.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StoreList(
                            count: index,
                            store: storesService.stores[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          storesService.selectStore = Store(
            name: '',
            country: '',
          );
          Navigator.pushNamed(context, StoreClientScreen.routeName);
        },
        child: const Icon(
          Icons.person_add_alt_rounded,
        ),
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
