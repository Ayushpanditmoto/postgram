import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static void show({
    required String msg,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(
      toastLength: Toast.LENGTH_SHORT,
      msg: msg,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.black,
      textColor: textColor ?? Colors.white,
      fontSize: fontSize ?? 16.0,
    );
  }

  //cancel previous toast
  static void cancelToast() {
    Fluttertoast.cancel();
  }
}
