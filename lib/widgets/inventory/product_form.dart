// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/models/models.dart';
import 'package:akicontrol/provider/provider.dart';
import 'package:akicontrol/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey dropdownCategoryKey = GlobalKey();
    final GlobalKey dropdownStoreKey = GlobalKey();

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    final storeService = Provider.of<StoresService>(context);
    List<DropdownMenuItem<String>> storeItems = [];

    if (storeService.stores.isNotEmpty) {
      storeItems = storeService.stores.map((Store store) {
        return DropdownMenuItem<String>(
          value: store.name,
          child: Text(store.name),
        );
      }).toList();

      storeItems.insert(
          0,
          const DropdownMenuItem<String>(
            value: 'No definido',
            child: Text('No definido'),
          ));
    } else {
      storeItems = [
        const DropdownMenuItem<String>(
          value: 'No definido',
          enabled: false,
          child: Text('No definido'),
        )
      ];
    }

    String? selectedStore;

    if (product.store != null &&
        product.store != 'No definido' &&
        !storeService.stores.any((store) => store.name == product.store)) {
      selectedStore = 'No definido';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        OverlayEntry overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: MediaQuery.of(context).size.height / 2 - 30,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                elevation: 10.0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color.fromARGB(221, 97, 30, 30),
                  child: const Text(
                    "El almacén asignado al producto ya no existe y ha sido reestablecido a 'No definido'.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        );

        Overlay.of(context).insert(overlayEntry);
        Future.delayed(const Duration(seconds: 5), () => overlayEntry.remove());
      });
    } else {
      selectedStore = product.store ?? 'No definido';
    }

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
                value: product.category.toString(),
                items: <String>[
                  'WiMax',
                  'Fibra óptica',
                  'Repetidores',
                  'Material de instalación',
                  'Otros'
                ].map((String value) {
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
                value: selectedStore,
                onChanged: (String? newValue) {
                  productForm.product.store = newValue;
                },
                items: storeItems,
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
                  updateAvailabilityBasedOnQuantity();
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

  void updateAvailabilityBasedOnQuantity() {
    final productForm =
        Provider.of<ProductFormProvider>(context, listen: false);
    final product = productForm.product;
    if (product.quantity == 0) {
      setState(() {
        product.available = false;
      });
    }
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          )
        ],
      );
}
