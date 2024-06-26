// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'akicontrol-48918-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  Product selectProduct = Product(
    available: false,
    category: '',
    name: '',
    quantity: 0,
    store: '',
  );

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
      await uploadImage();
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = jsonDecode(resp.body);

    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  void updateSelectProductImage(String path) {
    selectProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dblzfx0xk/image/upload?upload_preset=upload-preset');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(_baseUrl, 'products/$id.json');
    await http.delete(url);

    products.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
