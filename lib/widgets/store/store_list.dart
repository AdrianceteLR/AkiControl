// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/screens/screens.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreList extends StatelessWidget {
  const StoreList({
    super.key,
    required this.store,
    required this.count,
  });

  final Store store;
  final int count;

  @override
  Widget build(BuildContext context) {
    final storesService = Provider.of<StoresService>(context);

    if (storesService.isLoading) return const LoadingScreen();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          '${count + 1}.   ${store.name}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        trailing: const Icon(
          Icons.remove_red_eye_rounded,
          size: 35,
        ),
        onTap: () {
          storesService.selectStore = store.copy();
          Navigator.pushNamed(context, DetailsStoreScreen.routeName);
        },
      ),
    );
  }
}
