import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/features/booking/data/models/get_all_table_booking_response.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/app_urls.dart';
import '../../../../core/widgets/show_snackbar.dart';

class TableBookingDataSource {
  Future<bool> createBooking(
      {required int tableNo,
      required int seatNo,
      required String startDate,
      required String endDate,
      required String fromTime,
      required String toTime,
      required String displayname,
      required String floor}) async {
    var client = http.Client();

    try {
      var response = await client.post(Uri.parse(AppUrl.createTableBooking),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            "tableid": tableNo,
            "seatnumber": seatNo,
            "fromtime": fromTime,
            "totime": toTime,
            "selecteddate": startDate,
            "todate": endDate,
            "floor": floor,
            "roomtype": floor == 'Floor 14'
                ? getLevel14RoomType(displayname)
                : getLevel3RoomType(displayname),
            "tablename": displayname,
            // "current_time": AppHelpers.formatTime(TimeOfDay.now()),
            "employeeid":
                AppHelpers.SHARED_PREFERENCES.getInt('user_id') != null
                    ? AppHelpers.SHARED_PREFERENCES.getInt('user_id')
                    : 1,
          }));

      if (response.statusCode == 200) {
        var jsonString = response.body;

        showSnackBar(
            context: Get.context!,
            message: 'Booking Successful',
            bgColor: Colors.green);
        return true;
      } else {
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Invalid Booking',
            bgColor: Colors.red);
        return false;
      }
    } catch (e) {
      // showSnackBar(
      //     context: Get.context!, message: e.toString(), bgColor: Colors.red);
      print(e);
      return false;
    }
  }

  Future<bool> updateBooking({
    required int tableNo,
    required int seatNo,
    required String date,
    required String fromTime,
    required String toTime,
  }) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.updateTableBooking),
          //      headers: {
          //   HttpHeaders.contentTypeHeader: 'application/json'
          // },
          body: {
            "tableid": tableNo.toString(),
            "seatnumber": seatNo.toString(),
            "selecteddate": date,
            "fromtime": fromTime,
            "totime": toTime,
            "employeeid":
                AppHelpers.SHARED_PREFERENCES.getInt('user_id') != null
                    ? AppHelpers.SHARED_PREFERENCES.getInt('user_id').toString()
                    : 1,
          });
      if (response.statusCode == 200) {
        var jsonString = response.body;

        showSnackBar(
            context: Get.context!,
            message: 'Booking Successful',
            bgColor: Colors.green);
        return true;
      } else {
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Invalid Booking',
            bgColor: Colors.red);
        return false;
      }
    } catch (e) {
      // showSnackBar(
      //     context: Get.context!, message: e.toString(), bgColor: Colors.red);
      print(e);
      return false;
    }
  }

  Future<List<Map<int, int>>> viewAllBooking(Map<String, dynamic> data) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.tableAvailabalityNew),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        var jsonString = response.body;

        List<GetAllTableBookingResponse> bookings =
            getAllTableBookingResponseFromJson(jsonString);

        List<BookedSeats> bookedSeats = [];
        Map<int, List<int>> booked = {};
        for (var booking in bookings) {
          if (isNumeric(booking.tableid) &&
              isNumeric(booking.seatnumber) &&
              booking.status == 'Occupied') {
            bookedSeats.add(BookedSeats(
                tableNo: int.parse(booking.tableid),
                seatNo: int.parse(booking.seatnumber)));
            if (booked[int.parse(booking.tableid)] == null) {
              booked[int.parse(booking.tableid)] = [
                int.parse(booking.seatnumber)
              ];
            } else {
              if (!booked[int.parse(booking.tableid)]!
                  .contains(int.parse(booking.seatnumber))) {
                booked[int.parse(booking.tableid)]
                    ?.add(int.parse(booking.seatnumber));
              }
            }
          }
        }

        List<dynamic> jsondata = jsonDecode(response.body);

        List<Map<int, int>> tableData = [];

        jsondata.forEach((element) {
          Map<int, int> tableSeatDict = {
            int.parse(element["tableid"]): int.parse(element["seatnumber"])
            // jsonDecode(element)["tableid"]: jsonDecode(element)["seatno"]
          };

          tableData.add(tableSeatDict);
        });

        bookingController.tableData = tableData;

        // for (var i = 1; i < 8; i++) {
        //   modifiedTables[i] = [];
        //   for (var element in tableData) {
        //     if (element.containsKey(i)) {
        //       modifiedTables[i]?.add(element.values.first);
        //     }
        //   }
        // }
        //return tableData;
        bookedSeats.toSet().toList();

        bookingController.bookedSeats.value = booked;

        return tableData;
      } else {
        showSnackBar(
            context: Get.context!,
            message: 'Failed to Load',
            bgColor: Colors.red);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String getLevel3RoomType(String displayName) {
  switch (displayName) {
    case "HDS1":
    case "HDS2":
    case "HDS3":
    case "HDS4":
      return "BESPL";

    case "HDP1":
    case "HDP2":
    case "HDP3":
    case "HDP4":
    case "HDP5":
    case "HDP6":
    case "HDP7":
    case "HDP8":
      return "PAYROLL";

    default:
      return "GENERAL";
  }
}

String getLevel14RoomType(String displayName) {
  switch (displayName) {
    case "HDS1":
    case "HDS2":
    case "HDS3":
    case "HDS4":
    case "HDS5":
    case "HDS6":
    case "HDS7":
    case "HDS8":
    case "HDS9":
    case "HDS10":
    case "HDS11":
    case "HDS12":
    case "HDS13":
    case "HDS14":
    case "HDS715":
    case "HDS16":
    case "HDS17":
    case "HDS18":
    case "HDS19":
    case "HDS20":
    case "HDS21":
    case "HDS22":
    case "HDS23":
    case "HDS24":
      return "SRS";

    case "HDG1":
    case "HDG2":
    case "HDG3":
    case "HDG4":
    case "HDG5":
    case "HDG6":
    case "HDG7":
    case "HDG8":
    case "HDG9":
    case "HDG10":
    case "HDG11":
    case "HDG12":
    case "HDG13":
    case "HDG14":
    case "HDG715":
    case "HDG16":
    case "HDG17":
    case "HDG18":
    case "HDG19":
    case "HDG20":
    case "HDG21":
    case "HDG22":
    case "HDG23":
    case "HDG24":
    case "HDG725":
    case "HDG26":
    case "HDG27":
    case "HDG28":
    case "HDG29":
    case "HDG30":
    case "HDG31":
    case "HDG32":
    case "HDG33":
    case "HDG34":
      return "GENERAL";

    default:
      return "CS";
  }
}
