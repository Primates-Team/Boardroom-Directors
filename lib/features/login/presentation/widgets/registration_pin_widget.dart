import 'package:flutter/material.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/login/data/datasource/auth_datasource.dart';
import 'package:hot_desking/features/login/data/model/user_model.dart';
import 'package:hot_desking/features/login/presentation/widgets/successful_widget.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationPinWidget extends StatefulWidget {
  final UserModel user;
  const RegistrationPinWidget({Key? key, required this.user}) : super(key: key);

  @override
  _RegistrationPinWidgetState createState() => _RegistrationPinWidgetState();
}

class _RegistrationPinWidgetState extends State<RegistrationPinWidget> {
  bool isLoading = false;
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: size.width),
              Image.asset(
                'assets/common/logo.png',
                width: 248.w,
                height: 104.h,
              ),
              //New pin
              const SizedBox(
                height: 28,
              ),
              SizedBox(
                // height: 48.h,
                width: 343.w,
                child: Stack(
                  children: [
                    TextFormField(
                      controller: passwordController,
                      decoration: AppTheme.textFieldDecoration('New Pin'),
                      validator: (s) => s!.isEmpty ? 'Password Required' : null,
                      style: TextStyle(
                          color: AppColors.kDarkPantone,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
                      child: Image.asset(
                        'assets/common/key.png',
                        height: 25.h,
                        width: 25.w,
                        color: AppColors.kDarkPantone,
                      ),
                    )
                  ],
                ),
              ),
              //re type pin
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                // height: 48.h,
                width: 343.w,
                child: Stack(
                  children: [
                    TextFormField(
                      controller: confPasswordController,
                      decoration: AppTheme.textFieldDecoration('Re-Type Pin'),
                      validator: (s) => s!.isEmpty
                          ? 'Confirm Password Required'
                          : s == passwordController.text
                              ? null
                              : 'Password does not match',
                      style: TextStyle(
                          color: AppColors.kDarkPantone,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
                      child: Image.asset(
                        'assets/common/key.png',
                        height: 25.h,
                        width: 25.w,
                        color: AppColors.kDarkPantone,
                      ),
                    )
                  ],
                ),
              ),
              //register
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          UserModel userModel = UserModel(
                              firstName: widget.user.firstName,
                              lastName: widget.user.lastName,
                              gender: widget.user.gender,
                              designation: widget.user.designation,
                              mobile: widget.user.mobile,
                              email: widget.user.email,
                              password: passwordController.text,
                              profileUrl: widget.user.profileUrl);

                          AuthDataSource().signup(userModel).then((value) {
                            if (value) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const SuccessfulWidget(
                                        message: 'Registration Successful',
                                      ),
                                      duration:
                                          const Duration(milliseconds: 250)));
                            } else {
                              // showSnackBar(
                              //     context: context,
                              //     message: 'Registration Failed');
                            }
                          });
                        }
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
                    isLoading ? 'Registering' : 'Create Password',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
