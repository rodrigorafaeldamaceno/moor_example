import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get synchronized =>
      boolean().nullable().withDefault(const Constant(false))();
}
