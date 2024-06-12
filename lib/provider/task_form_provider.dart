import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isEditing = false;

  Task task;
  late Task _originalTask;

  TaskFormProvider(this.task) {
    _originalTask = task.copy();
    titleController.text = task.title;
    descriptionController.text = task.description;
    if (task.day != null) {
      dateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(task.day!));
    } else {
      dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  upddateAvailability(bool value) {
    task.finish = value;
    notifyListeners();
  }

  void restoreOriginalTask() {
    task = _originalTask.copy();
    titleController.text = _originalTask.title;
    descriptionController.text = _originalTask.description;
    if (_originalTask.day != null) {
      dateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(_originalTask.day!));
    } else {
      dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
    notifyListeners();
  }
}
