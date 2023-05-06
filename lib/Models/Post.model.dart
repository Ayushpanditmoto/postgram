import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String content;
  final String uid;
  final String name;
  final String profileUrl;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String photoUrl;
  final bool isApproved;

  const PostModel({
    required this.name,
    required this.profileUrl,
    required this.content,
    required this.uid,
    required this.likes,
    required this.postId,
    required this.datePublished,
    this.photoUrl = '',
    this.isApproved = false,
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      name: snapshot["name"],
      profileUrl: snapshot["profileUrl"],
      content: snapshot["content"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      photoUrl: snapshot['photoUrl'],
      isApproved: snapshot['isApproved'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "profileUrl": profileUrl,
        "content": content,
        "uid": uid,
        "likes": likes,
        "postId": postId,
        "datePublished": datePublished,
        'photoUrl': photoUrl,
        'isApproved': isApproved,
      };
}
