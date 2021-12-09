import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class MusicGenderFetcher extends MainFetcher {
  Future<List<MusicGender>> getMusicGenderList() async {
    final response = await this.get("music_genders");
    print(response);
    return listMusicgenderFromJson(response);
  }
}
