import 'package:flutter/material.dart';

void showSnackBar(
    ScaffoldMessengerState messengerState, String msg, Color color) {
  messengerState.showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: color, fontSize: 16),
      ),
    ),
  );
}
