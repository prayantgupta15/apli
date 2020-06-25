import 'dart:convert';

class UserModel {
  static String USER_ID_KEY = "user_id";
  static String PH_NO_KEY = "phoneNumber";
  static String PROFILE_PHOTO_KEY = "profilephotoUrl";
  static String EMAIL_KEY = "email";
  static String USERNAME_KEY = "username";
  static String ISPHONE_VERIFIED_KEY = "isPhoneVerified";

  UserModel(
      {this.uid,
      this.phoneNumber,
      this.email,
      this.username,
      this.profilephoto,
      this.isPhoneVerified});

  String uid;
  String phoneNumber;
  String email;
  String username;
  String status;
  String profilephoto;
  bool isPhoneVerified;

//  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//        uid: json[USER_ID_KEY] == null ? null : json[USER_ID_KEY],
//        phoneNumber: json[PH_NO_KEY] == null ? null : json[PH_NO_KEY],
//        email: json[EMAIL_KEY] == null ? null : json[EMAIL_KEY],
//        username: json[USERNAME_KEY] == null ? null : json[USERNAME_KEY],
//        profilephoto:
//            json[PROFILE_PHOTO_KEY] == null ? null : json[PROFILE_PHOTO_KEY],
//        isPhoneVerified: json[ISPHONE_VERIFIED_KEY] == null
//            ? null
//            : json[ISPHONE_VERIFIED_KEY],
//      );

  Map<String, dynamic> toJson() => {
        USER_ID_KEY: uid == null ? null : uid,
        PH_NO_KEY: phoneNumber == null ? null : phoneNumber,
        EMAIL_KEY: email == null ? null : email,
        USERNAME_KEY: username == null ? null : username,
        PROFILE_PHOTO_KEY: profilephoto == null ? null : profilephoto,
        ISPHONE_VERIFIED_KEY: isPhoneVerified == null ? null : isPhoneVerified,
      };
}
