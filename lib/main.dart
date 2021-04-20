import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/pages/product/product_page.dart';
import 'package:moor_example/utils/background_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

  BackgroundFetch.registerHeadlessTask(
    BackgroundHelper.backgroundFetchHeadlessTask,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline-Firt App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        // primaryColor: Colors.teal,
      ),
      home: ProductPage(),
    );
  }
}
