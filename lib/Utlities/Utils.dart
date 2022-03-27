import 'package:flutter/material.dart';

class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String text, Color color) {

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
