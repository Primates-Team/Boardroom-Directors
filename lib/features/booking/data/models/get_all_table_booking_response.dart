// To parse this JSON data, do
//
//     final getAllTableBookingResponse = getAllTableBookingResponseFromJson(jsonString);

import 'dart:convert';

List<GetAllTableBookingResponse> getAllTableBookingResponseFromJson(
        String str) =>
    List<GetAllTableBookingResponse>.from(
        json.decode(str).map((x) => GetAllTableBookingResponse.fromJson(x)));

String getAllTableBookingResponseToJson(
        List<GetAllTableBookingResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllTableBookingResponse {
  GetAllTableBookingResponse({
    required this.id,
    required this.tableid,
    required this.seatnumber,
    required this.employeeid,
    this.status,
    this.selecteddate,
    this.tabledetails,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String tableid;
  String seatnumber;
  String employeeid;
  dynamic status;
  dynamic selecteddate;
  dynamic tabledetails;
  DateTime createdAt;
  DateTime updatedAt;

  factory GetAllTableBookingResponse.fromJson(Map<String, dynamic> json) =>
      GetAllTableBookingResponse(
        id: json["id"],
        tableid: json["tableid"],
        seatnumber: json["seatnumber"],
        employeeid: json["employeeid"],
        status: json["status"],
        selecteddate: json["selecteddate"],
        tabledetails: json["tabledetails"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tableid": tableid,
        "seatnumber": seatnumber,
        "employeeid": employeeid,
        "status": status,
        "selecteddate": selecteddate,
        "tabledetails": tabledetails,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
