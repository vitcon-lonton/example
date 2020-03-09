import 'dart:convert';

import 'package:example/core/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider {
  static const String _key_sf = 'FAVORITE_SF_LIST';

  Future<bool> updateFavoriteToSF(List<People> peoples) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = jsonEncode(peoples);

    return prefs.setString(_key_sf, jsonString);
  }

  Future<List<People>> getFavoriteFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(_key_sf);

    try {
      List<dynamic> json = jsonDecode(stringValue);

      List<People> peoples = json
          .map(
            (item) => People.fromJson(item['user']),
          )
          .toList();

      return Future.value(peoples);
    } catch (e) {
      return Future.error(e);
    }
  }
}
