// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'package:akicontrol/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatelessWidget {
  final double _fontSize = 22;
  final double _fontSizeLabel = 20;

  final DateTime date;

  const TaskForm({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final taskForm = Provider.of<TaskFormProvider>(context);
    final task = taskForm.task;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: _buildBoxDecoration(),
          width: double.infinity,
          height: size.height * 0.85,
          child: SingleChildScrollView(
            child: Form(
              key: taskForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: taskForm.titleController,
                    onChanged: taskForm.isEditing
                        ? (value) => task.title = value
                        : null,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Título',
                      labelText: 'Título',
                      labelStyle: TextStyle(
                          fontSize: _fontSizeLabel, color: Colors.black),
                    ),
                    validator: (value) {
                      value = value?.replaceAll(' ', '');

                      if (value == null || value.isEmpty) {
                        return 'Debe introducir un título';
                      }
                      return null;
                    },
                    readOnly: !taskForm.isEditing,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: taskForm.descriptionController,
                    onChanged: taskForm.isEditing
                        ? (value) => task.description = value
                        : null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    minLines: 9,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Descripción',
                      labelText: 'Descripción',
                      labelStyle: TextStyle(fontSize: _fontSizeLabel),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                    ),
                    readOnly: !taskForm.isEditing,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: taskForm.dateController,
                    onTap: taskForm.isEditing
                        ? () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              locale: const Locale('es', 'ES'),
                              initialDate: date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null && pickedDate != date) {
                              task.day =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              taskForm.dateController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              taskForm.notifyListeners();
                            }
                          }
                        : null,
                    style: const TextStyle(fontSize: 24),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Fecha',
                      labelText: 'Fecha',
                      labelStyle: TextStyle(
                          fontSize: _fontSizeLabel, color: Colors.black),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                    ),
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
