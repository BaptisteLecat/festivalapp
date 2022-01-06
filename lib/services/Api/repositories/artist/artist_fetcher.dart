import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class ArtistFetcher extends MainFetcher {
  Future<List<Artist>> getArtistList() async {
    final response = await get(url: "artists");
    print(response.content);
    return listArtistFromJson(response.content);
  }
}
