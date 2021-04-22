import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';
import 'package:moor_example/utils/routes_api.dart';

class CategoryData {
  Future<Category> store({@required String name, @required int id}) async {
    Category category;
    try {
      Response response = await Dio().post(
        RoutesApi.CREATE_CATEGORY,
        data: {
          'name': name,
          'id': id,
        },
      );

      if (response.statusCode == 200)
        category = Category.fromJson(response.data);
    } catch (e, s) {
      debugPrint(e);
      debugPrint(s.toString());
    }
    return category;
  }

  Future<List<Category>> index() async {
    List<Category> list = [];
    try {
      Response<List> response = await Dio().get(RoutesApi.LIST_CATEGORIES);

      if (response.statusCode == 200)
        response.data.forEach((element) {
          list.add(Category.fromJson(element));
        });
    } catch (e) {
      return list;
    }
    return list;
  }

  Future<bool> delete({@required String uuid}) async {
    try {
      Response response = await Dio().delete(
        RoutesApi.CREATE_CATEGORY + '/$uuid',
      );

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }
}
