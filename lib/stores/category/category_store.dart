import 'package:mobx/mobx.dart';
import 'package:moor_example/db/database.dart';
part 'category_store.g.dart';

class CategoryStore = _CategoryStoreBase with _$CategoryStore;

abstract class _CategoryStoreBase with Store {
  final dao = MyDatabase.instance.categoryDAO;

  Stream<List<Category>> find() {
    return dao.find();
  }

  Future addCategory(Category category) {
    return dao.addCategory(category);
  }

  Future updateCategory(Category category) {
    return dao.updateCategory(category);
  }

  Future removeCategory(int id) {
    return dao.removeCategory(id);
  }
}
