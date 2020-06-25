import 'dart:convert';

class ImageModel {
  static String HASHTAG_KEY = "hashtag";
  static String IMG_URL_KEY = "image_url";
  static String NAME_KEY = "name";
  static String TIME_KEY = "timestamp";
  static String USERID_KEY = "user_id";

  ImageModel({this.uid, this.hashtag, this.image_url, this.name, this.time});

  String uid;
  String hashtag;
  String image_url;
  String name;
  DateTime time;

  Map<String, dynamic> toJson() => {
        USERID_KEY: uid == null ? null : uid,
        HASHTAG_KEY: hashtag == null ? null : hashtag,
        IMG_URL_KEY: image_url == null ? null : image_url,
        NAME_KEY: name == null ? null : name,
        TIME_KEY: time == null ? null : time,
      };
}
