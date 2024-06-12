// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsStoreScreen extends StatelessWidget {
  static String routeName = 'DetailsStore';

  const DetailsStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Provider.of<StoresService>(context);

    return ChangeNotifierProvider(
      create: (context) => StoreFormProvider(storeService.selectStore),
      child: _StoreClient(storesService: storeService),
    );
  }
}

class _StoreClient extends StatelessWidget {
  const _StoreClient({
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
                        onPressed: () async {
                          await dialogs(
                            context,
                            title: 'Eliminado correctamente',
                          );
                          await _deleteClient(context, storeForm.store.id);
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
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

                dialogs(
                  context,
                  title: 'Modificado correctamente',
                );

                await storesService.saveOrCreateStore(storeForm.store);
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

Future<void> _deleteClient(BuildContext context, String? clientId) async {
  if (clientId != null) {
    await Provider.of<StoresService>(context, listen: false)
        .deleteStore(clientId);
    Navigator.pop(context);
  }
}
