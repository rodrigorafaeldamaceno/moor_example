import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moor_example/db/database.dart';

class CategoryData {
  Future<bool> store({@required String name, @required int id}) async {
    try {
      Response response = await Dio().post(
        'https://moorserver.herokuapp.com/category',
        data: {
          'name': name,
          'id': id,
        },
      );

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Category>> index() async {
    var list = List<Category>();
    try {
      Response<List> response =
          await Dio().get('https://moorserver.herokuapp.com/categories');

      if (response.statusCode == 200)
        response.data.forEach((element) {
          list.add(Category.fromJson(element));
        });
      else
        return list;
    } catch (e) {
      return list;
    }
    return list;
  }
}
