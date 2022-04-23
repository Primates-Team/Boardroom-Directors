// To parse this JSON data, do
//
//     final getAllRoomBookingResponse = getAllRoomBookingResponseFromJson(jsonString);

import 'dart:convert';

List<GetAllRoomBookingResponse> getAllRoomBookingResponseFromJson(String str) =>
    List<GetAllRoomBookingResponse>.from(
        json.decode(str).map((x) => GetAllRoomBookingResponse.fromJson(x)));

String getAllRoomBookingResponseToJson(List<GetAllRoomBookingResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllRoomBookingResponse {
  GetAllRoomBookingResponse({
    required this.id,
    required this.roomid,
    required this.selecteddate,
    required this.fromtime,
    required this.totime,
    required this.employeeid,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String roomid;
  String selecteddate;
  String fromtime;
  String totime;
  String employeeid;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;

  factory GetAllRoomBookingResponse.fromJson(Map<String, dynamic> json) =>
      GetAllRoomBookingResponse(
        id: json["id"],
        roomid: json["roomid"],
        selecteddate: json["selecteddate"],
        fromtime: json["fromtime"],
        totime: json["totime"],
        employeeid: json["employeeid"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roomid": roomid,
        "selecteddate": selecteddate,
        "fromtime": fromtime,
        "totime": totime,
        "employeeid": employeeid,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
