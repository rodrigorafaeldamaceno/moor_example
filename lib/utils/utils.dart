import 'package:connectivity/connectivity.dart';
import 'package:moor_example/stores/category/category_store.dart';

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return (connectivityResult != ConnectivityResult.none);
}

Future synchronize() async {
  if (await checkConnection()) {
    print('sincronizando');
    await CategoryStore().synchronizedAllCategories();

    // await CategoryStore().listAllCategoriesFromServer();
  }
}
