import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CategoryData {
  Future<bool> store({@required String name, @required int id}) async {
    try {
      Response response = await Dio().post(
        'http://192.168.2.137:3333/category',
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
}
