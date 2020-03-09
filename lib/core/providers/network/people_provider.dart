import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:example/core/models/models.dart';

class PeopleProvider {
  static const String url_get_random_people =
      'https://randomuser.me/api/0.4/?randomapi';

  Dio _peopleClient;

  PeopleProvider() {
    // Init people client
    _peopleClient =
        new Dio(BaseOptions(validateStatus: (status) => status == 200));
  }

  // Get people from API
  Future<People> getRandomPeople() async {
    try {
      Response response = await _peopleClient.get(url_get_random_people);

      // Decode string to json
      Map<String, dynamic> json =
          jsonDecode(response.data)['results'][0]['user'];

      People people = People.fromJson(json);

      return Future.value(people);
    } catch (e) {
      return Future.error(e);
    }
  }
}
