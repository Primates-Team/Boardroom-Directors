import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/login/data/datasource/auth_datasource.dart';
import 'package:hot_desking/features/login/data/model/get_user_response.dart';
import 'package:hot_desking/features/login/presentation/widgets/otp_widget.dart';
import 'package:hot_desking/features/login/presentation/widgets/reset_password_widget.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPasswordController extends GetxController with StateMixin {
  TextEditingController controller = TextEditingController();

  String id = "";

  GetUserResponse? userResponse;
  void sendOtp() async {
    change(null, status: RxStatus.loading());
    var response = await AuthDataSource().sendOtp(controller.text.trim());

    if (response != null) {
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

    // if (userResponse != null) {
    //   change(null, status: RxStatus.success());
    // } else {
    //   change(null, status: RxStatus.error());
    // }

    var response = await AuthDataSource().verifyOtp(id, otp);

    if (response != null && response) {
      userResponse = await AuthDataSource().viewByEmail(controller.text.trim());
      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!);
      change(null, status: RxStatus.success());
      if (userResponse != null) {
        Navigator.push(
            Get.context!,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ResetPasswordWidget((password) {
                  userUpdate(userResponse!.id, password);
                }),
                duration: const Duration(milliseconds: 250)));
      }

      // Navigator.push(
      //     Get.context!,
      //     PageTransition(
      //         type: PageTransitionType.fade,
      //         child: const ResetPasswordScreen(),
      //         duration: const Duration(milliseconds: 250)));
    } else {
      change(null, status: RxStatus.error());
      showSnackBar(
          context: Get.context!,
          message: 'Failed to Load',
          bgColor: Colors.red);
    }
  }

  void userUpdate(int id, String password) async {
    change(null, status: RxStatus.loading());

    var response = await AuthDataSource().userUpdate(id, password);

    if (response != null) {
      Navigator.pop(Get.context!);
      // Navigator.pop(Get.context!);
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.error());
      showSnackBar(
          context: Get.context!,
          message: 'Failed to Load',
          bgColor: Colors.red);
    }
  }
}
