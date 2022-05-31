import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/login/presentation/pages/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController()).change(null, status: RxStatus.empty());

    Size size = MediaQuery.of(context).size;

    return GetBuilder<ForgotPasswordController>(
      builder: (logic) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                _buildScreenWidget(context, size, logic),
                if (logic.status.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Column _buildScreenWidget(
      BuildContext context, Size size, ForgotPasswordController logic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 10.w,
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
        //logo
        SizedBox(
          width: size.width,
          height: 132,
        ),
        Image.asset(
          'assets/common/logo.png',
          width: 248,
          height: 104,
        ),
        //mobile number
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          height: 48.h,
          width: 343.w,
          child: Stack(
            children: [
              TextFormField(
                decoration: AppTheme.textFieldDecoration('Email'),
                controller: logic.controller,
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
                child: Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
              )
              // TextFormField(
              //   decoration: AppTheme.textFieldDecoration('Mobile Number'),
              //   style: TextStyle(
              //       color: AppColors.kLightPantone, fontSize: 12.sp),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
              //   child: Image.asset(
              //     'assets/common/mobile.png',
              //     height: 25.h,
              //     width: 25.w,
              //     color: AppColors.kDarkPantone,
              //   ),
              // )
            ],
          ),
        ),
        //register
        SizedBox(
          height: 15.h,
        ),
        InkWell(
            onTap: () {
              logic.sendOtp();

              // Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.leftToRight,
              //         child: const OTPWidget(
              //           forgotPassword: true,
              //         ),
              //         duration: const Duration(milliseconds: 250)));
            },
            child: Container(
              height: 57.h,
              width: 343.w,
              decoration: BoxDecoration(
                color: AppColors.kAubergine,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                'Send OTP',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
            )),
      ],
    );
  }
}
