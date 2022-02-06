import 'dart:convert';
import 'dart:typed_data';

import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';

List<Artist> listArtistFromJson(dynamic str) =>
    List<Artist>.from(str.map((x) => Artist.fromJson(x)));

Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
  Artist({
    required this.iri,
    required this.id,
    required this.name,
    required this.musicGenders,
    required this.events,
    required this.picture,
  });

  String iri;
  int id;
  String name;
  List<MusicGender>? musicGenders;
  List<Event>? events;
  dynamic picture;

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      iri: json["@id"],
      id: (json["id"] == null) ? null : json["id"],
      name: (json["name"] == null) ? null : json["name"],
      musicGenders:
          (json["musicGenders"] == null || json["musicGenders"].isEmpty)
              ? []
              : (json["musicGenders"][0] is String)
                  ? []
                  : List<MusicGender>.from(
                      json["musicGenders"].map((x) => MusicGender.fromJson(x))),
      events: (json["events"] == null || json["events"].isEmpty)
          ? []
          : (json["events"][0] is String)
              ? []
              : List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      picture: json["picture"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": (name == null) ? null : name,
        "musicgenders": musicGenders == null
            ? null
            : (musicGenders!.isEmpty)
                ? []
                : List<dynamic>.from(musicGenders!.map((x) => x.iri)),
        "events": events == null
            ? null
            : (events!.isEmpty)
                ? []
                : List<dynamic>.from(events!.map((x) => x.iri)),
        "picture": picture,
      };

  Artist copy() => Artist(
        iri: iri,
        id: id,
        name: name,
        musicGenders: musicGenders,
        events: events,
        picture: picture,
      );

  Uint8List getPictureEncoded() {
    if (picture != null) {
      return const Base64Decoder().convert(picture);
    } else {
      throw Exception("Aucune image disponible");
    }
  }
}
