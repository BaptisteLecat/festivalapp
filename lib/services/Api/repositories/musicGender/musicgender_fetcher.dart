import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class MusicGenderFetcher extends MainFetcher {
  Future<List<MusicGender>> getMusicGenderList() async {
    final response = await get(url: "music_genders");
    print(response.content);
    return listMusicgenderFromJson(response.content);
  }
}
