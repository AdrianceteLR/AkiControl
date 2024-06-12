// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductInventoryScreen extends StatelessWidget {
  static String routeName = 'Product';

  const ProductInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productService.selectProduct),
      child: _ProductScreenBody(productsService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productsService,
  });

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const HomeBackground(),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ProductImage(
                              url: productsService.selectProduct.picture),
                          Positioned(
                            top: 60,
                            left: 20,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 20,
                            child: IconButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final PickedFile? pickedFile =
                                    await picker.getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100,
                                );

                                if (pickedFile == null) return;

                                productsService
                                    .updateSelectProductImage(pickedFile.path);
                              },
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ProductForm(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      heroTag: "deleteButton",
                      backgroundColor: const Color.fromARGB(255, 226, 34, 20),
                      onPressed: productsService.isSaving
                          ? null
                          : () async {
                              await _deleteProduct(
                                  context, productForm.product.id);
                              await dialogs(
                                context,
                                title: 'Eliminado correctamente',
                              );
                            },
                      child: productsService.isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.delete_rounded,
                            ),
                    ),
                    FloatingActionButton(
                      heroTag: "saveButton",
                      backgroundColor: const Color(0xFFF4A261),
                      onPressed: productsService.isSaving
                          ? null
                          : () async {
                              if (!productForm.isValidForm()) return;

                              final String? imageUrl =
                                  await productsService.uploadImage();

                              if (imageUrl != null) {
                                productForm.product.picture = imageUrl;
                              }

                              await productsService
                                  .saveOrCreateProduct(productForm.product);

                              await dialogs(
                                context,
                                title: 'Modificado correctamente',
                              );

                              Navigator.pop(context);
                            },
                      child: productsService.isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.save_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _deleteProduct(BuildContext context, String? productId) async {
  if (productId != null) {
    await Provider.of<ProductsService>(context, listen: false)
        .deleteProduct(productId);
    Navigator.pop(context);
  }
}
