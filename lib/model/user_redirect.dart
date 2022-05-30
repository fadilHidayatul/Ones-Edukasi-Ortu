// To parse this JSON data, do
//
//     final userDomain = userDomainFromJson(jsonString);

import 'dart:convert';

UserDomain userDomainFromJson(String str) => UserDomain.fromJson(json.decode(str));

String userDomainToJson(UserDomain data) => json.encode(data.toJson());

class UserDomain { 
    UserDomain({
        this.status,
        this.message,
        this.data,
    });

    String? status;
    String? message;
    Data? data;

    factory UserDomain.fromJson(Map<String, dynamic> json) => UserDomain(
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
        this.user,
        this.token,
        this.routes,
    });

    User? user;
    String? token;
    List<String>? routes = [];

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        token: json["token"],
        routes: List<String>.from(json["routes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "token": token,
        "routes": List<dynamic>.from(routes!.map((x) => x)),
    };
}

class User {
    User({
        this.idnya,
        this.name,
        this.email,
        this.phone,
        this.avatar,
    });

    String? idnya;
    String? name;
    String? email;
    String? phone;
    String? avatar;

    factory User.fromJson(Map<String, dynamic> json) => User(
        idnya: json["idnya"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "idnya": idnya,
        "name": name,
        "email": email,
        "phone": phone,
        "avatar": avatar,
    };
}
