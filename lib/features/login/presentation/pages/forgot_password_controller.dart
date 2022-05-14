import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/login/data/datasource/auth_datasource.dart';
import 'package:hot_desking/features/login/presentation/widgets/otp_widget.dart';
import 'package:page_transition/page_transition.dart';

import 'reset_password_screen.dart';

class ForgotPasswordController extends GetxController with StateMixin {
  TextEditingController controller = TextEditingController();

  String id = "";

  void sendOtp() async {
    change(null, status: RxStatus.loading());
    var response = await AuthDataSource().sendOtp(controller.text.trim());

    if (response != null) {
      print(response);
      change(null, status: RxStatus.success());

      id = response.id.toString();

      Navigator.push(
          Get.context!,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: OTPWidget(
                verifyOtp,
                forgotPassword: true,
              ),
              duration: const Duration(milliseconds: 250)));
    } else {
      change(null, status: RxStatus.error());
      showSnackBar(
          context: Get.context!,
          message: 'Failed to Load',
          bgColor: Colors.red);
    }
  }

  void verifyOtp(String otp) async {
    change(null, status: RxStatus.loading());
    var response = await AuthDataSource().verifyOtp(id, otp);

    if (response != null && response) {
      change(null, status: RxStatus.success());

      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!);
      Navigator.push(
          Get.context!,
          PageTransition(
              type: PageTransitionType.fade,
              child: const ResetPasswordScreen(),
              duration: const Duration(milliseconds: 250)));
    } else {
      change(null, status: RxStatus.error());
      showSnackBar(
          context: Get.context!,
          message: 'Failed to Load',
          bgColor: Colors.red);
    }
  }
}
