import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get qtd => integer()();
  RealColumn get price => real()();
  IntColumn get idCategory => integer().named('id_category')();
}
