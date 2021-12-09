import 'dart:convert';

import 'package:festivalapp/model/music_gender.dart';

List<Artist> listArtistFromJson(dynamic str) =>
    List<Artist>.from(str.map((x) => Artist.fromJson(x)));

Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
  Artist({
    required this.id,
    required this.name,
    required this.musicGenders,
    required this.picture,
  });

  int id;
  String name;
  List<Musicgender>? musicGenders;
  dynamic picture;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? null : json["name"],
        musicGenders: (json["musicGenders"] == null)
            ? null
            : List<Musicgender>.from(json["musicGenders"].map((x) => x)),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "musicGenders": musicGenders == null
            ? null
            : List<Musicgender>.from(musicGenders!.map((x) => x)),
        "picture": picture,
      };
}
