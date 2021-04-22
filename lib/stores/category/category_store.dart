import 'package:mobx/mobx.dart';
import 'package:moor_example/data/category_data.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/utils/utils.dart';
part 'category_store.g.dart';

class CategoryStore = _CategoryStoreBase with _$CategoryStore;

abstract class _CategoryStoreBase with Store {
  final dao = MyDatabase.instance.categoryDAO;
  final _data = CategoryData();

  Stream<List<Category>> find() {
    return dao.find();
  }

  Future<List<Category>> findList() {
    return dao.findList();
  }

  Future addCategory(Category category, {bool needSynchronize: true}) async {
    await dao.addCategory(category);

    if (needSynchronize) synchronize();
  }

  Future updateCategory(Category category) {
    return dao.updateCategory(category);
  }

  Future removeCategory(int id) {
    return dao.removeCategory(id);
  }

  Future<bool> removeCategoryFromServer(String uuid) {
    return _data.delete(uuid: uuid);
  }

  Future synchronizedAllCategories() async {
    final categories = await dao.findCategoriesUnsynchronized();

    categories.forEach((category) async {
      final response = await _data.store(
        name: category.name,
        id: category.id,
      );

      if (response) {
        await updateCategory(
          category.copyWith(synchronized: true),
        );
      } else {
        print(
            'falha ao atualizar o categoria ${category.id} - ${category.name}');
      }
    });
  }

  Future listAllCategoriesFromServer() async {
    final list = await _data.index();

    if (list.isEmpty || list == null) return;

    await (dao.delete(dao.categories)
          ..where((tbl) => tbl.synchronized.equals(true)))
        .go();

    return list.forEach((element) async {
      await addCategory(
        element.copyWith(synchronized: true),
        needSynchronize: false,
      );
    });
  }
}
