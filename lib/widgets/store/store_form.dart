// ignore_for_file: depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreForm extends StatelessWidget {
  final double _fontSize = 24;
  final double _fontSizeLabel = 20;

  const StoreForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final storeForm = Provider.of<StoreFormProvider>(context);
    final store = storeForm.store;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 110),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          decoration: _buildBoxDecoration(),
          width: double.infinity,
          height: size.height * 0.75,
          child: SingleChildScrollView(
            child: Form(
              key: storeForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(
                        Icons.warehouse_rounded,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    initialValue: store.name,
                    onChanged: (value) => store.name = value,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: _fontSize),
                    decoration: InputDecoration(
                        hintText: 'Nombre del almacén',
                        labelText: 'Nombre almacén',
                        labelStyle: TextStyle(fontSize: _fontSizeLabel)),
                    validator: (value) {
                      value = value?.replaceAll(' ', '');

                      if (value == null || value.isEmpty) {
                        return 'El nombre del almacén no puede estar vacío';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    initialValue: store.country,
                    onChanged: (value) => store.country = value,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: _fontSize),
                    decoration: InputDecoration(
                        hintText: 'Ubicación del almacén',
                        labelText: 'Ubicación almacén',
                        labelStyle: TextStyle(fontSize: _fontSizeLabel)),
                    validator: (value) {
                      value = value?.replaceAll(' ', '');

                      if (value == null || value.isEmpty) {
                        return value = '';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      );
}
