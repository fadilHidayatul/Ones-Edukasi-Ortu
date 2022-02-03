// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.status,
        this.header,
        this.data,
    });

    String? status;
    String? header;
    Data? data;

    factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        header: json["header"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "header": header,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.user,
        this.token,
        this.routes,
    });

    UserClass? user;
    String? token;
    List<String>? routes;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: UserClass.fromJson(json["user"]),
        token: json["token"],
        routes: List<String>.from(json["routes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "routes": List<dynamic>.from(routes!.map((x) => x)),
    };
}

class UserClass {
    UserClass({
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

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
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
