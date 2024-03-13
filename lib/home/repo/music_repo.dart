import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:music_player/home/model/music_model.dart';

abstract class MusicRepository {
  Future<MusicModel> musicList({required data});
}

class MusicRepositoryImpl extends MusicRepository {

  @override
  Future<MusicModel> musicList({data}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://www.jsonkeeper.com/b/U6H1"),
      );
      if (response.statusCode == 500) {
        var data = {"status": 500, "error": "Error", "data": []};
        MusicModel listModel = MusicModel.fromJson(data);
        return listModel;
      } else {
        var data = json.decode(response.body);
        MusicModel listModel = MusicModel.fromJson(data);
        return listModel;
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
}