// To parse this JSON data, do
//
//     final getUserResponse = getUserResponseFromJson(jsonString);

import 'dart:convert';

List<GetUserResponse> getUserResponseFromJson(String str) =>
    List<GetUserResponse>.from(
        json.decode(str).map((x) => GetUserResponse.fromJson(x)));

String getUserResponseToJson(List<GetUserResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUserResponse {
  GetUserResponse({
    required this.id,
    required this.firstname,
    required this.email,
    required this.password,
    required this.lastname,
    required this.gender,
    this.phone,
    this.role,
    this.designation,
    this.address,
    this.city,
    this.dob,
    this.imei,
    this.lastscanned,
    this.status,
    this.profilepic,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String firstname;
  String? email;
  String? password;
  String lastname;
  String gender;
  String? phone;
  String? role;
  dynamic designation;
  dynamic address;
  dynamic city;
  dynamic dob;
  dynamic imei;
  dynamic lastscanned;
  dynamic status;
  dynamic profilepic;
  DateTime createdAt;
  DateTime updatedAt;

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      GetUserResponse(
        id: json["id"],
        firstname: json["firstname"],
        email: json["email"],
        password: json["password"],
        lastname: json["lastname"],
        gender: json["gender"],
        phone: json["phone"],
        role: json["role"],
        designation: json["designation"],
        address: json["address"],
        city: json["city"],
        dob: json["dob"],
        imei: json["imei"],
        lastscanned: json["lastscanned"],
        status: json["status"],
        profilepic: json["profilepic"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "email": email,
        "password": password,
        "lastname": lastname,
        "gender": gender,
        "phone": phone,
        "role": role,
        "designation": designation,
        "address": address,
        "city": city,
        "dob": dob,
        "imei": imei,
        "lastscanned": lastscanned,
        "status": status,
        "profilepic": profilepic,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
