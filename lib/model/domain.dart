// To parse this JSON data, do
//
//     final domain = domainFromJson(jsonString);

import 'dart:convert';

Domain domainFromJson(String str) => Domain.fromJson(json.decode(str));

String domainToJson(Domain data) => json.encode(data.toJson());

class Domain {
    Domain({
        this.domains,
        this.userStatus,
    });

    List<DomainElement>? domains = [];
    UserStatus? userStatus;

    factory Domain.fromJson(Map<String, dynamic> json) => Domain(
        domains: List<DomainElement>.from(json["domains"].map((x) => DomainElement.fromJson(x))),
        userStatus: UserStatus.fromJson(json["user_status"]),
    );

    Map<String, dynamic> toJson() => {
        "domains": List<dynamic>.from(domains!.map((x) => x.toJson())),
        "user_status": userStatus!.toJson(),
    };
}

class DomainElement {
    DomainElement({
        this.key,
        this.client,
        this.domain,
        this.url,
        this.application,
        this.feeService,
        this.period,
        this.isActive,
    });

    String? key;
    String? client;
    String? domain;
    String? url;
    Application? application;
    int? feeService;
    String? period;
    bool? isActive;

    factory DomainElement.fromJson(Map<String, dynamic> json) => DomainElement(
        key: json["key"],
        client: json["client"],
        domain: json["domain"],
        url: json["url"],
        application: Application.fromJson(json["application"]),
        feeService: json["fee_service"],
        period: json["period"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "client": client,
        "domain": domain,
        "url": url,
        "application": application!.toJson(),
        "fee_service": feeService,
        "period": period,
        "is_active": isActive,
    };
}

class Application {
    Application({
        this.name,
        this.descriptions,
        this.bannerPath,
        this.isActive,
    });

    String? name;
    String? descriptions;
    String? bannerPath;
    int? isActive;

    factory Application.fromJson(Map<String, dynamic> json) => Application(
        name: json["name"],
        descriptions: json["descriptions"],
        bannerPath: json["banner_path"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "descriptions": descriptions,
        "banner_path": bannerPath,
        "is_active": isActive,
    };
}

class UserStatus {
    UserStatus({
        this.haveSchool,
        this.havePending,
        this.amountPending,
    });

    bool? haveSchool;
    bool? havePending;
    int? amountPending;

    factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
        haveSchool: json["have_school"],
        havePending: json["have_pending"],
        amountPending: json["amount_pending"],
    );

    Map<String, dynamic> toJson() => {
        "have_school": haveSchool,
        "have_pending": havePending,
        "amount_pending": amountPending,
    };
}
