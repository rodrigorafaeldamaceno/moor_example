import 'package:moor_example/db/database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'category_dao.g.dart';

@UseDao(tables: [Categories, Categories])
class CategoryDAO extends DatabaseAccessor<MyDatabase> with _$CategoryDAOMixin {
  CategoryDAO(MyDatabase db) : super(db);

  Stream<List<Category>> find() {
    return (select(categories).watch());
  }

  Future addCategory(Category category) {
    return into(categories).insert(category);
  }

  Future updateCategory(Category category) {
    return update(categories).replace(category);
  }

  Future removeCategory(int id) {
    return (delete(categories)..where((cat) => cat.id.equals(id))).go();
  }
}
