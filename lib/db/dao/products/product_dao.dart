import 'package:moor_example/db/database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'product_dao.g.dart';

@UseDao(tables: [Products, Categories])
class ProductDAO extends DatabaseAccessor<MyDatabase> with _$ProductDAOMixin {
  ProductDAO(MyDatabase db) : super(db);
}
