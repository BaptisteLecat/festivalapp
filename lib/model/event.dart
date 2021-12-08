// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  Event({
    required this.id,
    required this.artists,
    required this.date,
  });

  int id;
  List<Artist> artists;
  DateTime date;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        artists:
            List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "date": date.toIso8601String(),
      };
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
