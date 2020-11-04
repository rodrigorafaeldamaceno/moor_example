import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'dao/category/category_dao.dart';
import 'dao/products/product_dao.dart';

part 'database.g.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get qtd => integer()();
  RealColumn get price => real()();
  IntColumn get idCategory => integer().named('id_category')();
}

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Products, Categories])
class MyDatabase extends _$MyDatabase {
  static MyDatabase instance = MyDatabase._internal();

  MyDatabase._internal() : super(_openConnection());

  ProductDAO productDAO = ProductDAO(instance);
  CategoryDAO categoryDAO = CategoryDAO(instance);

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}