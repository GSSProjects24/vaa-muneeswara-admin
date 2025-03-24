import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vaa_muneeswara_admin/Color/app_color.dart';
import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';
import 'package:vaa_muneeswara_admin/UI/Drawer/drawer.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true; // <-- added this

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                image: DecorationImage(
                  image: AssetImage('images/app_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: height,
              color: AppTheme.whiteColor,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/app_logo.png',
                            height: 100,
                          ),
                          SizedBox(height: 30),

                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 10),

                          Text(
                            "Login to continue",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ),

                          SizedBox(height: 30),
                          TextFormField(
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                  color: AppTheme.primaryColor, fontSize: 14),
                              prefixIcon: Icon(Icons.email,
                                  color: AppTheme.primaryColor),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppTheme.primaryColor.withOpacity(0.1),
                            ),
                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            obscureText: _obscureText,
                            style: TextStyle(color: AppTheme.primaryColor),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  color: AppTheme.primaryColor, fontSize: 14),
                              prefixIcon: Icon(Icons.lock,
                                  color: AppTheme.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,size: 22,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: togglePasswordVisibility,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppTheme.primaryColor.withOpacity(0.1),
                            ),
                          ),

                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.buttonColor,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.buttonTextColor,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
