import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget cancelButton() {
  return Container(
    height: 50.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 2.0)),
    child: const Center(child: Text('Cancel Booking')),
  );
}
