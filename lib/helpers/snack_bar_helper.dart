import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomSnackBar {
  static void showCustomSnackBar(
    GlobalKey<ScaffoldMessengerState> scaffoldKey,
    String contentText, {
    Color color = Colors.red,
  }) {
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(contentText),
        backgroundColor: color,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 3.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
