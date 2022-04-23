import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/booking/presentation/pages/hot_desking_screen.dart';
import 'package:hot_desking/features/login/presentation/pages/login_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../booking/presentation/pages/room_booking_screen.dart';
import '../../../booking/presentation/pages/calender_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String firstName =
      AppHelpers.SHARED_PREFERENCES.getString('firstName') ?? 'John';
  String lastName =
      AppHelpers.SHARED_PREFERENCES.getString('lastName') ?? 'Doe';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      AppHelpers.SHARED_PREFERENCES.clear();
                      pushAndRemoveUntilScreen(context,
                          screen: const LoginScreen(), withNavBar: false);
                    },
                    child: Image.asset(
                      'assets/welcome_screen/log_out.png',
                      height: 30,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/welcome_screen/person_emoji.png',
                    height: 55,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 22.sp),
                      children: [
                        const TextSpan(
                          text: 'Welcome ',
                          style: TextStyle(
                            color: AppColors.kAubergine,
                          ),
                        ),
                        TextSpan(
                          text: '$firstName $lastName',
                          style: const TextStyle(
                            color: AppColors.kEvergreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              optionsButton(
                  title: 'Meeting room booking',
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: const RoomBookingScreen(
                        type: 'meeting room',
                      ),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }),
              optionsButton(
                  title: 'Hot desking',
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: const HotDeskingScreen(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }),
              optionsButton(
                  title: 'Calendar',
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: const CalenderScreen(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget optionsButton({
    required String title,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 114.h,
        width: 183.w,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.all(14),
        decoration: AppTheme.boxDecoration,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
