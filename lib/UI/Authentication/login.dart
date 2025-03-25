import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Color/app_color.dart';
import 'package:vaa_muneeswara_admin/Controller/login_controller.dart';

class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>(); // Form key for validation

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
                      child: Form(
                        key: _formKey, // Attach form key
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
                              controller: controller.emailController,
                              style: TextStyle(color: AppTheme.primaryColor),
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppTheme.primaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText: controller.obscureText.value,
                              style: TextStyle(color: AppTheme.primaryColor),
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock, color: AppTheme.primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscureText.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 22,
                                    color: AppTheme.primaryColor,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppTheme.primaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                return null;
                              },
                            )),
                            SizedBox(height: 30),
                            Obx(() => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.adminLogin();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.buttonColor,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: controller.isLoading.value
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.buttonTextColor,
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(height: 20),
                          ],
                        ),
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
