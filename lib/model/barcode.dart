// To parse this JSON data, do
//
//     final barcode = barcodeFromJson(jsonString);

import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/model/event.dart';
import 'dart:convert';

List<Barcode> listBarcodeFromJson(dynamic str) =>
    List<Barcode>.from(str.map((x) => Barcode.fromJson(x)));

Barcode barcodeFromJson(String str) => Barcode.fromJson(json.decode(str));

String barcodeToJson(Barcode data) => json.encode(data.toJson());

class Barcode {
  Barcode({
    required this.iri,
    required this.id,
    required this.code,
    required this.event,
    required this.user,
    required this.expirationDate,
    required this.lastname,
    required this.firstname,
  });

  String? iri;
  int id;
  String code;
  Event event;
  AppUser user;
  DateTime expirationDate;
  String lastname;
  String firstname;

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        iri: json["@id"],
        id: json["id"],
        code: json["code"],
        event: Event.fromJson(json["event"]),
        user: AppUser.fromJson(json["user"]),
        expirationDate: DateTime.parse(json["expirationDate"]),
        lastname: json["lastname"],
        firstname: json["firstname"],
      );

  Map<String, dynamic> toJson() => {
        "@id": iri,
        "id": id,
        "code": code,
        "event": event.toJson(),
        "user": user.toJson(),
        "expirationDate": expirationDate.toIso8601String(),
        "lastname": lastname,
        "firstname": firstname,
      };
}
