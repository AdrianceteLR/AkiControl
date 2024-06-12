// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoresService extends ChangeNotifier {
  final String _baseUrl =
      'akicontrol-48918-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Store> stores = [];

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  Store selectStore = Store(
    name: '',
    country: '',
  );

  StoresService() {
    loadStores();
  }

  Future loadStores() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'stores.json');
    final resp = await http.get(url);

    final Map<String, dynamic> clientsMap = json.decode(resp.body);

    clientsMap.forEach((key, value) {
      final tempStore = Store.fromMap(value);
      tempStore.id = key;

      stores.add(tempStore);
    });

    isLoading = false;
    notifyListeners();

    return stores;
  }

  Future saveOrCreateStore(Store store) async {
    isSaving = true;
    notifyListeners();

    if (store.id == null) {
      await createStore(store);
    } else {
      await updateStore(store);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateStore(Store store) async {
    final url = Uri.https(_baseUrl, 'stores/${store.id}.json');
    final resp = await http.put(url, body: store.toJson());
    final decodedData = resp.body;

    final index = stores.indexWhere((element) => element.id == store.id);
    stores[index] = store;

    return store.id!;
  }

  Future<String> createStore(Store store) async {
    final url = Uri.https(_baseUrl, 'stores/.json');
    final resp = await http.post(url, body: store.toJson());
    final decodedData = jsonDecode(resp.body);

    store.id = decodedData['name'];
    stores.add(store);

    return store.id!;
  }

  Future<void> deleteStore(String id) async {
    final url = Uri.https(_baseUrl, 'stores/$id.json');
    await http.delete(url);

    stores.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
