import 'package:moor_example/db/database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'product_dao.g.dart';

@UseDao(tables: [Products, Categories])
class ProductDAO extends DatabaseAccessor<MyDatabase> with _$ProductDAOMixin {
  ProductDAO(MyDatabase db) : super(db);

  Stream<List<Product>> find() {
    return (select(products).watch());
  }

  Future addProduct(Product product) {
    return into(products).insert(product);
  }

  Future updateProduct(Product product) {
    return update(products).replace(product);
  }

  Future removeProduct(int id) {
    return (delete(products)..where((product) => product.id.equals(id))).go();
  }
}
