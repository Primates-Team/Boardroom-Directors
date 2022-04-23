import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/features/booking/data/datasource/room_booking_datasource.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';
import 'package:hot_desking/features/home/presentation/pages/home_screen_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/login/presentation/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppHelpers.SHARED_PREFERENCES = await SharedPreferences.getInstance();
  TableBookingDataSource().viewAllBooking();
  RoomBookingDataSource().viewAllRoomBooking();
  Get.put(BookingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AppHelpers.SHARED_PREFERENCES.getString('email') != null;
    print(AppHelpers.SHARED_PREFERENCES.getInt('user_id').toString());
    return ScreenUtilInit(
      designSize: const Size(390, 800),
      builder: (_) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          home: isLoggedIn ? const HomeScreenMain() : const LoginScreen(),
        );
      },
    );
  }
}
