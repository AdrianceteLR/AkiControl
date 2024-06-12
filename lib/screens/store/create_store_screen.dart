// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:akicontrol/services/stores_service.dart';
import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreClientScreen extends StatelessWidget {
  static String routeName = 'CreateStore';

  const StoreClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoresService>(context);

    return ChangeNotifierProvider(
      create: (context) => StoreFormProvider(storeService.selectStore),
      child: _StoreClientScreen(storesService: storeService),
    );
  }
}

class _StoreClientScreen extends StatelessWidget {
  const _StoreClientScreen({
    required this.storesService,
  });

  final StoresService storesService;
  @override
  Widget build(BuildContext context) {
    final storeForm = Provider.of<StoreFormProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const HomeBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    const StoreForm(),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.warehouse_rounded,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF4A261),
        onPressed: storesService.isSaving
            ? null
            : () async {
                if (!storeForm.isValidForm()) return;

                await storesService.saveOrCreateStore(storeForm.store);

                await dialogs(
                  context,
                  title: 'Creado correctamente',
                );

                Navigator.pop(context);
              },
        child: storesService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.save_rounded,
              ),
      ),
    );
  }
}
