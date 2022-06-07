import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';

class ResetPasswordWidget extends StatefulWidget {
  ResetPasswordWidget(this.onSubmit, {Key? key}) : super(key: key);

  Function onSubmit;

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  bool isLoading = false;
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConformPassword = false;

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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          AppTheme.textFieldDecoration("New Pin").copyWith(
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => showPassword = !showPassword),
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: showPassword
                                ? AppColors.kDarkPantone
                                : AppColors.kLightPantone,
                          ),
                        ),
                      ),
                      obscureText: showPassword,

                      validator: (s) {
                        const String pattern =
                            r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$)';

                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(s!))
                          return 'Password should be Minimum ten characters, at least one uppercase letter, one lowercase letter, one number and one special character';
                        else
                          return null;
                      },
                      // validator: (s) => s!.isEmpty ? 'Password Required' : null,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          AppTheme.textFieldDecoration('Re-Type Pin').copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                              () => showConformPassword = !showConformPassword),
                          icon: Icon(
                            showConformPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: showConformPassword
                                ? AppColors.kDarkPantone
                                : AppColors.kLightPantone,
                          ),
                        ),
                      ),
                      obscureText: showConformPassword,
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
                          widget.onSubmit(confPasswordController.text.trim());
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
