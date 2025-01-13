import 'dart:convert';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/user/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserModel> getUserData(String userId) async {
    final response = await http.get(Uri.parse('$BASE_URL/users/$userId'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
