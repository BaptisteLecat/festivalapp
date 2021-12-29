// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

import 'dart:typed_data';

import 'package:festivalapp/common/constants/data.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/music_gender.dart';

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
    required this.musicgenders,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.price,
  });

  int id;
  List<Artist>? artists;
  DateTime date;
  String picture;
  String name;
  DateTime endDate;
  List<MusicGender>? musicgenders;
  String description;
  double? latitude;
  double? longitude;
  double? price;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        artists: json["artists"] == null
            ? null
            : List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
        date: DateTime.parse(json["date"]),
        picture: json["picture"] == null ? null : json["picture"],
        name: json["name"],
        endDate: DateTime.parse(json["endDate"]),
        musicgenders: json["musicgenders"] == null
            ? null
            : List<MusicGender>.from(
                json["musicgenders"].map((x) => MusicGender.fromJson(x))),
        description: json["description"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        price: json["price"] == null ? null : json["price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "artists": List<dynamic>.from(artists!.map((x) => x.toJson())),
        "date": date.toIso8601String(),
        "name": name,
        "picture": (picture != null) ? picture : null,
        "endDate": endDate.toIso8601String(),
        "musicgenders": musicgenders == null
            ? null
            : List<dynamic>.from(musicgenders!.map((x) => x.toJson())),
        "description": description,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "price": price == null ? null : price,
      };

  String _getMonth(int index) {
    return const_monthLabel[index - 1];
  }

  String getDateOfEvent() {
    return "${date.day} - ${endDate.day} ${_getMonth(endDate.month)}, ${endDate.year}";
  }

  String getDateOfEventTicket() {
    return "${date.day} ${_getMonth(date.month)} ${date.year}";
  }

  Uint8List getPictureEncoded() {
    if (picture != null) {
      return const Base64Decoder().convert(picture);
    } else {
      throw Exception("Aucune image disponible");
    }
  }
}
