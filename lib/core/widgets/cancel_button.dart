import 'package:flutter/material.dart';

Widget cancelButton() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 2.0)),
    child: const Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Text('Cancel Booking'),
    )),
  );
}
