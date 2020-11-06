import 'package:moor_example/db/database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'product_dao.g.dart';

class ProductWithNameCategory {
  final Product product;
  final String nameCategory;

  ProductWithNameCategory({this.product, this.nameCategory});
}

@UseDao(tables: [Products, Categories])
class ProductDAO extends DatabaseAccessor<MyDatabase> with _$ProductDAOMixin {
  ProductDAO(MyDatabase db) : super(db);

  Stream<List<Product>> find() {
    return (select(products).watch());
  }

  Stream<List<ProductWithNameCategory>> findProductsWithNameCategory() {
    return customSelect(
        'SELECT products.*, categories.name AS categoryName FROM products INNER JOIN categories ON products.id_category = categories.id',
        readsFrom: {
          products,
          categories,
        }).watch().map((rows) {
      return rows
          .map((row) => ProductWithNameCategory(
              product: Product.fromData(row.data, this.db),
              nameCategory: row.readString('categoryName')))
          .toList();
    });
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
