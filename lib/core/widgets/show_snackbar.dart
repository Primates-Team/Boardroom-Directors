import 'package:flutter/material.dart';
import 'package:hot_desking/core/app_colors.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Color bgColor = AppColors.kNavyBlue,
}) {
  final snackBar = SnackBar(
    backgroundColor: bgColor,
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.left,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
