import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';

class StoreFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Store store;

  StoreFormProvider(this.store);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
