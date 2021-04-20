// import 'package:background_fetch/background_fetch.dart';
// import 'package:moor_example/db/database.dart';
// import 'package:moor_example/stores/category/category_store.dart';
// import 'package:moor_example/utils/utils.dart';

// class BackgroundHelper {
//   /// This "Headless Task" is run when app is terminated.
//   static void backgroundFetchHeadlessTask(String taskId) async {
//     print('[BackgroundFetch] Headless event received.');
//     await CategoryStore().synchronizedAllCategories();

//     BackgroundFetch.finish(taskId);
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   static Future<void> initPlatformState() async {
//     // Configure BackgroundFetch.
//     BackgroundFetch.configure(
//         BackgroundFetchConfig(
//             minimumFetchInterval: 15,
//             stopOnTerminate: false,
//             enableHeadless: false,
//             requiresBatteryNotLow: false,
//             requiresCharging: false,
//             requiresStorageNotLow: false,
//             requiresDeviceIdle: false,
//             requiredNetworkType: NetworkType.ANY), (String taskId) async {
//       // This is the fetch-event callback.
//       print("[BackgroundFetch] Event received $taskId");
//       // await synchronize();
//       await CategoryStore().synchronizedAllCategories();
//       // setState(() {
//       //   _events.insert(0, new DateTime.now());
//       // });
//       // CategoryStore().synchronizedAllCategories();
//       // IMPORTANT:  You must signal completion of your task or the OS can punish your app
//       // for taking too long in the background.
//       BackgroundFetch.finish(taskId);
//     }).then((int status) {
//       print('[BackgroundFetch] configure success: $status');
//       // setState(() {
//       //   _status = status;
//       // });
//     }).catchError((e) {
//       print('[BackgroundFetch] configure ERROR: $e');
//       // setState(() {
//       //   _status = e;
//       // });
//     });

//     // Optionally query the current BackgroundFetch status.
//     // int status = await BackgroundFetch.status;
//     // setState(() {
//     //   _status = status;
//     // });

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     // if (!mounted) return;
//   }
// }
