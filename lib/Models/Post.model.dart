// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String postId;
  String uuid;
  String content;
  String photoUrl;
  List<String> like;

  PostModel({
    required this.postId,
    required this.uuid,
    required this.content,
    required this.photoUrl,
    required this.like,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        postId: json["postId"],
        uuid: json["uuid"],
        content: json["content"],
        photoUrl: json["photoUrl"],
        like: List<String>.from(json["like"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "uuid": uuid,
        "content": content,
        "photoUrl": photoUrl,
        "like": List<dynamic>.from(like.map((x) => x)),
      };
}
