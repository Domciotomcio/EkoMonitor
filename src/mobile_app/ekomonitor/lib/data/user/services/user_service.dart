import 'dart:convert';
import 'dart:developer';

import 'package:ekomonitor/data/const.dart';
import 'package:ekomonitor/data/user/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserModel> getUserData(int userId) async {
    final response = await http.get(Uri.parse('http://localhost:8004/users/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      Map<String, dynamic> userMap = {
        'userId': data[0],
        'firstName': data[1],
        'lastName': data[2],
        'city': data[3],
        'email': data[4],
        'password': data[5],
      };
      return UserModel.fromJson(userMap);
    } else {
      log('Failed to load user data: ${response.statusCode}');
      throw Exception('Failed to load user data');
    }
  }
}
