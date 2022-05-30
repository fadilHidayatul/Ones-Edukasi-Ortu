// To parse this JSON data, do
//
//     final userLogin = userLoginFromJson(jsonString);

import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
    UserLogin({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    Data? data;

    factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
    };
}

class Data {
    Data({
        this.detail,
        this.accessToken,
        this.tokenType,
        this.has,
    });

    Detail? detail;
    String? accessToken;
    String? tokenType;
    List<String>? has = [""];

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        detail: Detail.fromJson(json["detail"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        has: json["has"]!=null ?  List<String>.from(json["has"].map((x) => x)) : [""],
    );

    Map<String, dynamic> toJson() => {
        "detail": detail!.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
        "has": List<dynamic>.from(has!.map((x) => x)),
    };
}

class Detail {
    Detail({
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.isVerified,
        this.socialPassword,
        this.avatar,
    });

    String? firstName;
    String? lastName;
    String? email;
    dynamic phoneNumber;
    bool? isVerified;
    bool? socialPassword;
    String? avatar;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        isVerified: json["is_verified"],
        socialPassword: json["social_password"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "is_verified": isVerified,
        "social_password": socialPassword,
        "avatar": avatar,
    };
}
