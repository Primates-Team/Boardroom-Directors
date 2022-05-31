import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_urls.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:http/http.dart' as http;

class BookingHistoryDataSource {
  Future<bool> getBookingHistory() async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.viewByEmployee),
          //      headers: {
          //   HttpHeaders.contentTypeHeader: 'application/json'
          // },
          body: {
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
            message: 'History Fetched Successfully',
            bgColor: Colors.green);
        return true;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Error loading data',
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

  Future<bool> getCurrentHistory(String date, String time) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.viewByTime),
          //      headers: {
          //   HttpHeaders.contentTypeHeader: 'application/json'
          // },
          body: {
            "selecteddate": date,
            'time': time,
          });
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(jsonString);
        showSnackBar(
            context: Get.context!,
            message: 'Data Fetched Successfully',
            bgColor: Colors.green);
        return true;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Error loading data',
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
}
