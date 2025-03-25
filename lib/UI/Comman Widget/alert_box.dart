import 'package:flutter/material.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';

import '../../Style and Color/font_style.dart';
import 'button.dart';

class CustomAlertBox {
  static void show(
      BuildContext context, {
        required String title,
        required String description,
        required String okButtonText,
        required VoidCallback onOkPressed,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            title,
            style: TextStyles.textStyle(18, AppTheme.primaryColor,weight: FontWeight.bold),
          ),
          content: Text(
            description,
            style: TextStyles.textStyle(16, AppTheme.black ),
          ),
          actions: [

            Button(
              buttonText: 'Cancel',
              backgroundColor: AppTheme.grey,
              fontColor: AppTheme.black,
              onPressed: () {

                Navigator.of(context).pop();
              },

            ),
            Button(
              buttonText: okButtonText,
              backgroundColor: AppTheme.secondaryColor,
              onPressed: () {
                onOkPressed();
                Navigator.of(context).pop();
              },

            ),
          ],
        );
      },
    );
  }
}
