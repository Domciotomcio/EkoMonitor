import 'dart:convert';
import 'dart:developer';

import 'package:ekomonitor/data/user_profile/models/user_profile_model.dart';
import 'package:ekomonitor/views/form/form_view.dart';
import 'package:http/http.dart' as http;

class UserProfileService {
  Future<UserProfileModel> getUserProfileData(int userId) async {
    final response =
        await http.get(Uri.parse('http://localhost:8005/user_answers/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      Map<String, dynamic> userProfileMap = {
        'answerId': data[0],
        'userId': data[1],
        'answers': <String>[],
        'userProfile': data[7],
      };

      (userProfileMap['answers'] as List<String>).add(data[2]);
      (userProfileMap['answers'] as List<String>).add(data[3]);
      (userProfileMap['answers'] as List<String>).add(data[4]);
      (userProfileMap['answers'] as List<String>).add(data[5]);
      (userProfileMap['answers'] as List<String>).add(data[6]);

      return UserProfileModel.fromJson(userProfileMap);
    } else {
      log('Failed to load user profile data: ${response.statusCode}');
      throw Exception('Failed to load user profile data');
    }
  }

  Future<void> updateUserProfileWithForm(
      String userId, List<Question> answers) async {
    // fetch user profile from server
    var answerMap = {
      "user_id": userId,
      "outdoor_activities": answers[0].selectedAnswer,
      "health_concerns": answers[1].selectedAnswer,
      "daily_commute": answers[2].selectedAnswer,
      "gardening": answers[3].selectedAnswer,
      "weather_interest": answers[4].selectedAnswer,
    };

    log(answerMap.toString());

    final response = await http.put(
      Uri.parse('http://localhost:8005/user_answers/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(answerMap),
    );

    if (response.statusCode != 200) {
      log('Failed to update user profile data: ${response.statusCode}');
      throw Exception('Failed to update user profile data');
    }
  }
}
