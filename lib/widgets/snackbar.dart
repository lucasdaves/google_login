import 'package:flutter/material.dart';

class SnackBarWidget {
  static SnackBar loginSnack({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
