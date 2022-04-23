import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_urls.dart';
import 'package:hot_desking/features/login/data/model/get_user_response.dart';
import 'package:hot_desking/features/login/data/model/user_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/app_helpers.dart';
import '../../../../core/widgets/show_snackbar.dart';

class AuthDataSource {
  Future<bool> signup(UserModel user) async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.createUser),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            "firstname": user.firstName,
            "email": user.email,
            "password": user.password,
            "lastname": user.lastName,
            "gender": user.gender,
            "designation": user.designation,
            "phone": user.mobile,
            // "address": null,
            // "city": null,
            // "dob": null,
            // "imei": null,
            // "lastscanned": null,
            // "status": null,
            "profilepic": user.profileUrl
          }));
      if (response.statusCode == 200) {
        print(response.body);
        showSnackBar(context: Get.context!, message: 'Registered Successfully');
        AppHelpers.SHARED_PREFERENCES.setString('email', user.email);
        AppHelpers.SHARED_PREFERENCES.setString('firstName', user.firstName);
        AppHelpers.SHARED_PREFERENCES.setString('lastName', user.lastName);
        AppHelpers.SHARED_PREFERENCES.setString('phone', user.mobile);
        return true;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Registration Failed',
            bgColor: Colors.red);
        return false;
      }
    } catch (e) {
      showSnackBar(
          context: Get.context!, message: e.toString(), bgColor: Colors.red);
      return false;
    }
  }

  Future<bool> login(String? email, String? password) async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(AppUrl.viewAllUsers),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        List<GetUserResponse> users = getUserResponseFromJson(jsonString);
        for (var user in users) {
          if (user.email == email && user.password == password) {
            AppHelpers.SHARED_PREFERENCES.setString('email', user.email!);
            AppHelpers.SHARED_PREFERENCES.setString('password', user.password!);
            AppHelpers.SHARED_PREFERENCES
                .setString('firstName', user.firstname);
            AppHelpers.SHARED_PREFERENCES.setString('lastName', user.lastname);
            AppHelpers.SHARED_PREFERENCES.setString('phone', user.phone ?? '');
            AppHelpers.SHARED_PREFERENCES.setInt('user_id', user.id);
            AppHelpers.SHARED_PREFERENCES.setString('role', user.role ?? '');
            AppHelpers.SHARED_PREFERENCES
                .setString('designation', user.designation ?? '');
            AppHelpers.SHARED_PREFERENCES.setString('phone', user.phone ?? '');
            AppHelpers.SHARED_PREFERENCES
                .setString('profilepic', user.profilepic ?? '');
            AppHelpers.SHARED_PREFERENCES.setString('gender', user.gender);
            return true;
          }
        }
        showSnackBar(
            context: Get.context!,
            message: 'Email / Password doesn\'t exists',
            bgColor: Colors.red);
        return false;
      } else {
        print(response.statusCode);
        // LoginFailureResponse res = loginFailureResponseFromJson(response.body);
        showSnackBar(
            context: Get.context!,
            message: 'Registration Failed',
            bgColor: Colors.red);
        return false;
      }
    } catch (e) {
      showSnackBar(
          context: Get.context!, message: e.toString(), bgColor: Colors.red);
      print(e);
      return false;
    }
  }
}
