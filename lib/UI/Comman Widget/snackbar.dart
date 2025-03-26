import 'package:flutter/material.dart';

class Snackbar {
  static void showOrangeSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.deepOrange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showGreenSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.green.shade900,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
