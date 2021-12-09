import 'dart:convert';

List<Musicgender> listMusicgenderFromJson(dynamic str) =>
    List<Musicgender>.from(str.map((x) => Musicgender.fromJson(x)));

Musicgender musicGenderFromJson(String str) =>
    Musicgender.fromJson(json.decode(str));

String musicGenderToJson(Musicgender data) => json.encode(data.toJson());

class Musicgender {
  Musicgender({
    required this.id,
    required this.label,
  });

  int id;
  String label;

  factory Musicgender.fromJson(Map<String, dynamic> json) => Musicgender(
        id: (json["id"] == null) ? null : json["id"],
        label: (json["label"] == null) ? null : json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "label": (label == null) ? null : label,
      };
}
