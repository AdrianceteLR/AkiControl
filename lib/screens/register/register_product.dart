// ignore_for_file: sort_child_properties_last, depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/services/services.dart';
import 'package:akicontrol/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterProduct extends StatelessWidget {
  static String routeName = 'Registro';

  const RegisterProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productService.selectProduct),
      child: _RegisterProduct(productsService: productService),
    );
  }
}

class _RegisterProduct extends StatelessWidget {
  const _RegisterProduct({
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
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ProductImage(url: productsService.selectProduct.picture),
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
                          final PickedFile? pickedFile = await picker.getImage(
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
                _ProductForm(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF4A261),
        child: productsService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.save_rounded,
              ),
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imageUrl = await productsService.uploadImage();

                if (imageUrl != null) productForm.product.picture = imageUrl;

                await productsService.saveOrCreateProduct(productForm.product);

                await dialogs(
                  context,
                  title: 'Creado correctamente',
                );

                Navigator.pop(context);
              },
      ),
    );
  }
}

class _ProductForm extends StatefulWidget {
  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  final List<String> _categories = [
    'WiMax',
    'Fibra óptica',
    'Repetidores',
    'Material de instalación',
    'Otros'
  ];

  String? _selectedStore;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    final storeService = Provider.of<StoresService>(context);

    final GlobalKey dropdownCategoryKey = GlobalKey();
    final GlobalKey dropdownStoreKey = GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  value = value;
                  value = value?.replaceAll(' ', '');

                  if (value == null || value.isEmpty) {
                    return 'El nombre del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              DropdownButtonFormField<String>(
                key: dropdownCategoryKey,
                value: product.category,
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  product.category = newValue!;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Elegir una categoria',
                ),
              ),
              const SizedBox(height: 50),
              DropdownButtonFormField<String>(
                key: dropdownStoreKey,
                value: _selectedStore,
                items: storeService.stores.map((Store store) {
                  return DropdownMenuItem<String>(
                    value: store.name.toString(),
                    child: Text(store.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStore = newValue;
                  });
                  productForm.product.store = newValue;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Elegir un almacén',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.quantity}',
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    product.quantity = 0;
                  } else {
                    product.quantity = int.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+$'))
                ],
                decoration: const InputDecoration(
                  hintText: 'Cantidad',
                  labelText: 'Cantidad',
                ),
                validator: (value) {
                  value = value?.replaceAll(' ', '');

                  if (value == null || value.isEmpty) {
                    return 'Debe introducir una cantidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Disponible'),
                onChanged: productForm.updateAvailability,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      );
}
