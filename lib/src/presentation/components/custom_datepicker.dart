import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomDatePicker {
  static Future<DateTime?> showPicker(BuildContext context) async {
    return await showDatePicker(
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: blueColor,
          colorScheme: const ColorScheme.light(primary: blueColor),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      ),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
}
