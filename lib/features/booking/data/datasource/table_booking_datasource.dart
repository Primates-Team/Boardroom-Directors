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
  Future<bool> createBooking({
    required int tableNo,
    required int seatNo,
    required String date,
    required String fromTime,
    required String toTime,
  }) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.createTableBooking),
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
        print(jsonString);
        showSnackBar(
            context: Get.context!,
            message: 'Booking Successful',
            bgColor: Colors.green);
        return true;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Booking Failed',
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
        print(jsonString);
        showSnackBar(
            context: Get.context!,
            message: 'Booking Successful',
            bgColor: Colors.green);
        return true;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Boking Failed',
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

  Future viewAllBooking() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(AppUrl.viewAllTableBookings),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(jsonString);
        List<GetAllTableBookingResponse> bookings =
            getAllTableBookingResponseFromJson(jsonString);

        List<BookedSeats> bookedSeats = [];
        Map<int, List<int>> booked = {};
        for (var booking in bookings) {
          if (isNumeric(booking.tableid) && isNumeric(booking.seatnumber)) {
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
        bookedSeats.toSet().toList();
        print(bookedSeats);
        bookingController.bookedSeats.value = booked;
        print(booked);

        return true;
      } else {
        print(response.statusCode);
        showSnackBar(
            context: Get.context!,
            message: 'Failed to Load',
            bgColor: Colors.red);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
