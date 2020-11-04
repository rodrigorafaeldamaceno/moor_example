import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/stores/category/category_store.dart';
part 'products_store.g.dart';

class ProductsStore = _ProductsStoreBase with _$ProductsStore;

abstract class _ProductsStoreBase with Store {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final qtdController = TextEditingController();
  Category selectedCategory;

  final _categoryController = CategoryStore();
  final _dao = MyDatabase.instance.productDAO;

  Stream<List<Product>> find() {
    return _dao.find();
  }

  Future addProduct() async {
    final product = Product(
      id: null,
      name: nameController.text,
      description: descriptionController.text,
      qtd: int.parse(qtdController.text),
      price: double.parse(priceController.text),
      idCategory: selectedCategory.id,
    );

    return _dao.addProduct(product);
  }

  Future updateProduct(Product product) {
    return _dao.updateProduct(product);
  }

  Future removeProduct(int id) {
    return _dao.removeProduct(id);
  }

  Stream<List<Category>> findCategories() {
    return _categoryController.find();
  }
}
