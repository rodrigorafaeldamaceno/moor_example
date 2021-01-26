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

  Future addCategory(Category category) async {
    await dao.addCategory(category);

    synchronize();
    return;
  }

  Future updateCategory(Category category) {
    return dao.updateCategory(category);
  }

  Future removeCategory(int id) {
    return dao.removeCategory(id);
  }

  Future synchronizedAllCategories() async {
    final categories = await dao.findCategoriesUnsynchronized();

    print(categories.toList());

    categories.forEach((category) async {
      final response = await _data.store(
        name: category.name,
        id: category.id,
      );

      if (response) {
        updateCategory(
          Category(
            id: category.id,
            name: category.name,
            synchronized: true,
          ),
        );
      } else {
        print(
            'falha ao atualizar o categoria ${category.id} - ${category.name}');
      }
    });

    // print(response);
  }
}
