// To parse this JSON data, do
//
//     final appUser = appUserFromJson(jsonString);

import 'dart:convert';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.firstname,
    required this.email,
    required this.roles,
    required this.jwt,
  });

  int id;
  String name;
  String firstname;
  String email;
  List<String>? roles;
  String? jwt;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json["id"],
        name: json["name"],
        firstname: json["firstname"],
        email: json["email"],
        roles: (json["roles"] != null)
            ? List<String>.from(json["roles"].map((x) => x))
            : null,
        jwt: json["jwt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "firstname": firstname,
        "email": email,
        "roles":
            (roles != null) ? List<dynamic>.from(roles!.map((x) => x)) : null,
        "jwt": jwt,
      };

  bool isAdmin() {
    bool isAdmin = false;
    if (roles != null) {
      for (String role in roles!) {
        if (role == "ROLE_ADMIN") {
          isAdmin = true;
          break;
        }
      }
    }
    return isAdmin;
  }
}
