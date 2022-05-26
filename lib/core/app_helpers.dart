import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHelpers {
  static List<BoxShadow> boxShadowList = const [
    BoxShadow(
        color: Color.fromRGBO(31, 31, 31, 0.9),
        blurRadius: 10,
        offset: Offset(5, 5)),
    BoxShadow(
        color: Color.fromRGBO(62, 62, 62, 0.9),
        blurRadius: 10,
        offset: Offset(-5, -5)),
    BoxShadow(
        color: Color.fromRGBO(31, 31, 31, 0.2),
        blurRadius: 10,
        offset: Offset(5, -5)),
    BoxShadow(
        color: Color.fromRGBO(31, 31, 31, 0.2),
        blurRadius: 10,
        offset: Offset(-5, 5)),
    BoxShadow(
        color: Color.fromRGBO(31, 31, 31, 0.5),
        blurRadius: 2,
        blurStyle: BlurStyle.inner,
        offset: Offset(-1, -1)),
    BoxShadow(
        color: Color.fromRGBO(51, 51, 51, 0.3),
        blurRadius: 2,
        blurStyle: BlurStyle.inner,
        offset: Offset(1, 1)),
  ];

  static List<BoxShadow> bottomNavigatorShadowList = const [
    BoxShadow(
        color: Color.fromRGBO(23, 23, 23, 0.9),
        blurRadius: 3,
        blurStyle: BlurStyle.inner,
        offset: Offset(1, 1)),
    BoxShadow(
        color: Color.fromRGBO(59, 59, 59, 0.9),
        blurRadius: 2,
        blurStyle: BlurStyle.inner,
        offset: Offset(-1, -1)),
    BoxShadow(
        color: Color.fromRGBO(23, 23, 23, 0.2),
        blurRadius: 2,
        blurStyle: BlurStyle.inner,
        offset: Offset(1, -1)),
    BoxShadow(
        color: Color.fromRGBO(23, 23, 23, 0.2),
        blurRadius: 2,
        blurStyle: BlurStyle.inner,
        offset: Offset(-1, 1)),
    BoxShadow(
        color: Color.fromRGBO(23, 23, 23, 0.5),
        blurRadius: 2,
        offset: Offset(-1, -1)),
    BoxShadow(
        color: Color.fromRGBO(59, 59, 59, 0.3),
        blurRadius: 2,
        offset: Offset(1, 1)),
  ];

  static String formatDate(DateTime value) {
    var date =
        '${value.day.toString().length == 1 ? "0${value.day}" : value.day}-${value.month.toString().length == 1 ? "0${value.month}" : value.month}-${value.year}';
    return date;
  }

  static String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().length != 2
        ? '0${time.hour}'
        : time.hour.toString();
    String min = time.minute.toString().length != 2
        ? '0${time.minute}'
        : time.minute.toString();
    var t = '$hour:$min';
    print(t);
    return t;
  }

  static void showCupertinoTimePicker(BuildContext context,
      void Function(DateTime) onDateTimeChanged, DateTime minimumDate,
      {TimeOfDay? initialTimeofDay, bool isEnddate = false}) {
    DateTime initialDateTime = DateTime.now();

    DateTime? selectableTime;

    if (isEnddate) {
      selectableTime = minimumDate;
    } else if (minimumDate.day == DateTime.now().day) {
      selectableTime = minimumDate;
    } else {
      selectableTime = null;
    }

    if (initialTimeofDay != null) {
      initialDateTime = DateTime(initialDateTime.year, initialDateTime.month,
          initialDateTime.day, initialTimeofDay.hour, initialTimeofDay.minute);
    }

    int initialMinute = initialDateTime.minute;

    if (initialDateTime.minute % 15 != 0) {
      initialMinute = initialDateTime.minute - initialDateTime.minute % 15 + 15;
    }
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: onDateTimeChanged,
              minuteInterval: 15,
              use24hFormat: true,
              minimumDate: selectableTime,
              initialDateTime: DateTime(
                  initialDateTime.year,
                  initialDateTime.month,
                  initialDateTime.day,
                  initialDateTime.hour,
                  initialMinute),
            ),
          );
        });
  }

  static late SharedPreferences SHARED_PREFERENCES;
}

BookingController bookingController = BookingController.instance;
const String squareChair = 'assets/level3/square_chair.png';
const String ovalChair = 'assets/level3/oval_chair.png';
const String table4Seater = 'assets/level3/table4.png';
const String table6Seater = 'assets/level3/table6.png';
const String table8Seater = 'assets/level3/table8.png';
//
const String simpleTable = 'assets/rooms/simple_table.png';
const String semiCircleTable = 'assets/rooms/semi_circle_table.png';
const String longTable = 'assets/rooms/long_table.png';
const String starChair = 'assets/rooms/star_chair.png';
const String semiCircleChair = 'assets/rooms/semi_circle_chair.png';
