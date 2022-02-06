import 'dart:convert';

import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class ArtistFetcher extends MainFetcher {
  Future<List<Artist>> getArtistList() async {
    final response = await get(url: "artists");
    print(response.content);
    return listArtistFromJson(response.content);
  }

  Future<Artist> postArtist({required Artist artist}) async {
    final response =
        await postEntity(url: "artists", body: jsonEncode(artist.toJson()));
    print(response.content);
    return Artist.fromJson(response.content);
  }

  Future<Artist> putArtist({required Artist artist}) async {
    final response =
        await put(url: "artists/${artist.id}", body: artist.toJson());
    print(response.content);
    return Artist.fromJson(response.content);
  }

  Future<int> deleteArtist({required Artist artist}) async {
    final response = await delete(url: "artists/${artist.id}");
    print(response.content);
    return response.statusCode;
  }
}
