import 'package:flutter/material.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/font_style.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? fontColor;

  const Button({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.backgroundColor,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Button shadow effect
        shadowColor: Colors.black54,
        backgroundColor: backgroundColor,
      ),
      child: Text(buttonText,style: TextStyles.textStyle(12, fontColor ?? AppTheme.buttonTextColor),),
    );
  }
}
