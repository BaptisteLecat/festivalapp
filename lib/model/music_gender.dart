import 'dart:convert';

List<MusicGender> listMusicgenderFromJson(dynamic str) =>
    List<MusicGender>.from(str.map((x) => MusicGender.fromJson(x)));

MusicGender musicGenderFromJson(String str) =>
    MusicGender.fromJson(json.decode(str));

String musicGenderToJson(MusicGender data) => json.encode(data.toJson());

class MusicGender {
  MusicGender({
    required this.id,
    required this.label,
  });

  int id;
  String label;

  factory MusicGender.fromJson(Map<String, dynamic> json) => MusicGender(
        id: (json["id"] == null) ? null : json["id"],
        label: (json["label"] == null) ? null : json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "label": (label == null) ? null : label,
      };
}
