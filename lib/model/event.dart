// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:typed_data';

import 'package:festivalapp/common/constants/data.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<Event> listEventFromJson(dynamic str) =>
    List<Event>.from(str.map((x) => Event.fromJson(x)));

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    required this.id,
    required this.artists,
    required this.date,
    required this.picture,
    required this.name,
    required this.endDate,
  });

  int id;
  List<Artist> artists;
  DateTime date;
  String name;
  String? picture;
  DateTime endDate;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      id: json["id"],
      artists:
          List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
      date: DateTime.parse(json["date"]),
      name: json["name"],
      picture: json["picture"],
      endDate: DateTime.parse(json["endDate"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "date": date.toIso8601String(),
        "name": name,
        "picture": (picture != null) ? picture : "",
        "endDate": endDate.toIso8601String(),
      };

  String _getMonth(int index) {
    return const_monthLabel[index - 1];
  }

  String getDateOfEvent() {
    return "${date.day} - ${endDate.day} ${_getMonth(endDate.month)}, ${endDate.year}";
  }

  Uint8List getPictureEncoded() {
    if (picture != null) {
      return const Base64Decoder().convert(picture!);
    } else {
      throw Exception("Aucune image disponible");
    }
  }
}

class Artist {
  Artist({
    required this.id,
    required this.name,
    required this.musicGenders,
  });

  int id;
  String name;
  List<dynamic> musicGenders;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        musicGenders: List<dynamic>.from(json["musicGenders"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "musicGenders": List<dynamic>.from(musicGenders.map((x) => x)),
      };
}
