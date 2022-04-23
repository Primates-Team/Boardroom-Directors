import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget(
      {Key? key,
        required this.selectedIndex,
        required this.onItemSelected,});


  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        color: AppColors.kAubergine,
        height: 200.0,
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);

    final centerAvatar = Offset(shapeBounds.center.dx, -15);
//2
    final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: 50);

    Path path = Path()
      ..moveTo(shapeBounds.left, shapeBounds.bottom) //3
      ..lineTo(shapeBounds.topLeft.dx, shapeBounds.topLeft.dy) //4
      ..arcTo(avatarBounds, pi, -pi, false) //5
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //6
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //7
      ..close(); //

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}