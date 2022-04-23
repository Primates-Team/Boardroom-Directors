import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/home/presentation/pages/home_screen_main.dart';
import 'package:hot_desking/features/login/data/datasource/auth_datasource.dart';
import 'package:hot_desking/features/login/presentation/pages/forgot_password_screen.dart';
import 'package:hot_desking/features/login/presentation/pages/signin_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //logo
                SizedBox(height: 60.h),
                Image.asset(
                  'assets/common/logo.png',
                  width: 248.w,
                  height: 104.h,
                ),
                //text
                Text(
                  'Welcome',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.kAubergine),
                ),
                //text
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: AppColors.kAubergine,
                  ),
                ),
                //user name
                SizedBox(
                  height: 28.h,
                ),
                SizedBox(
                  // height: 48.h,
                  width: 343.w,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: AppTheme.textFieldDecoration('Email'),
                        style: TextStyle(
                            color: AppColors.kDarkPantone,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                        validator: (s) =>
                            GetUtils.isEmail(s!) ? null : 'Enter valid email',
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
                        child: Image.asset(
                          'assets/login/user_name.png',
                          height: 25,
                          width: 25,
                          color: AppColors.kDarkPantone,
                        ),
                      )
                    ],
                  ),
                ),
                //password
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  // height: 48.h,
                  width: 343.w,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _password,
                        obscureText: !showPassword,
                        decoration:
                            AppTheme.textFieldDecoration('Password').copyWith(
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
                        style: TextStyle(
                            color: AppColors.kDarkPantone, fontSize: 15.sp),
                        validator: (s) =>
                            s!.isEmpty ? 'Password required' : null,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0.h, left: 11.w),
                        child: Image.asset(
                          'assets/login/password.png',
                          height: 25.h,
                          width: 25.w,
                          color: AppColors.kDarkPantone,
                        ),
                      )
                    ],
                  ),
                ),
                //sign in button
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await AuthDataSource()
                          .login(_email.text, _password.text)
                          .then((value) {
                        if (value) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const HomeScreenMain(),
                                  duration: const Duration(milliseconds: 250)));
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 57.h,
                    width: 343.w,
                    decoration: BoxDecoration(
                      color: AppColors.kAubergine,
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    child: Center(
                        child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
                  ),
                ),
                //forgot password
                SizedBox(height: 16.h),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const ForgotPasswordScreen(),
                            duration: const Duration(milliseconds: 250))),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: AppColors.kAubergine),
                    )),
                //register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don’t have a account?  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColors.kLightPantone)),
                    InkWell(
                        onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const SignInScreen(),
                                duration: const Duration(milliseconds: 250))),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: AppColors.kAubergine),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
