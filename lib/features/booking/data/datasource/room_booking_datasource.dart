import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';
import 'package:hot_desking/features/booking/data/models/get_all_room_booking_response.dart';
import 'package:http/http.dart' as http;
import '../../../../core/app_urls.dart';
import '../../../../core/widgets/show_snackbar.dart';

class RoomBookingDataSource {
  Future<bool> createRoomBooking({
    required int roomId,
    required String date,
    required String fromTime,
    required String toTime,
    required List<String> members,
  }) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.createRoomBooking),
          //      headers: {
          //   HttpHeaders.contentTypeHeader: 'application/json'
          // },
          body: {
            "roomid": roomId.toString(),
            "selecteddate": date,
            "fromtime": fromTime,
            "totime": toTime,
            "email" : jsonEncode(members),
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

  Future viewAllRoomBooking() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(AppUrl.viewAllRoomBookings),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(jsonString);
        List<GetAllRoomBookingResponse> bookings =
            getAllRoomBookingResponseFromJson(jsonString);

        // List<BookedSeats> bookedSeats = [];
        List<int> booked = [];
        for (var booking in bookings) {
          if (isNumeric(booking.roomid)) {
            // bookedSeats.add(BookedSeats(
            //     tableNo: int.parse(booking.tableid),
            //     seatNo: int.parse(booking.seatnumber)));
            booked.add(int.parse(booking.roomid));
          }
        }
        booked.toSet().toList();
        bookingController.bookedRooms.value = booked;
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
