// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  String uuid;
  String email;
  String profilePic;
  List<String> followers;
  List<String> following;

  UserModel({
    required this.name,
    required this.uuid,
    required this.email,
    required this.profilePic,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        uuid: json["uuid"],
        email: json["email"],
        profilePic: json["profilePic"],
        followers: List<String>.from(json["followers"].map((x) => x)),
        following: List<String>.from(json["following"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid,
        "email": email,
        "profilePic": profilePic,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
      };
}
