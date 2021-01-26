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
    print(category.toJson());
    return into(categories).insert(category).catchError((e) => print(e));
  }

  Future updateCategory(Category category) {
    return update(categories).replace(category).catchError((e) => print(e));
  }

  Future removeCategory(int id) {
    return (delete(categories)..where((cat) => cat.id.equals(id)))
        .go()
        .catchError((e) => print(e));
  }

  Future<List<Category>> findCategoriesUnsynchronized() {
    return (select(categories)
          ..where((category) => category.synchronized.equals(false)))
        .get()
        .catchError((e) => print(e));
  }
}
