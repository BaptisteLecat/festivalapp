import 'dart:convert';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class MusicGenderFetcher extends MainFetcher {
  Future<List<MusicGender>> getMusicGenderList() async {
    final response = await get(url: "music_genders");
    print(response.content);
    return listMusicgenderFromJson(response.content);
  }

  Future<MusicGender> putMusicGender({required MusicGender musicGender}) async {
    final response = await put(
        url: "music_genders/${musicGender.id}", body: musicGender.toJson());
    print(response.content);
    return MusicGender.fromJson(response.content);
  }

  Future<MusicGender> postMusicGender(
      {required MusicGender musicGender}) async {
    final response = await postEntity(
        url: "music_genders", body: jsonEncode(musicGender.toJson()));
    print(response.content);
    return MusicGender.fromJson(response.content);
  }

  Future<int> deleteMusicGender({required MusicGender musicGender}) async {
    final response = await delete(url: "music_genders/${musicGender.id}");
    print(response.content);
    return response.statusCode;
  }
}
