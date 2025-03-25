import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';

class LoginController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final box = GetStorage();
  var isLoading = false.obs;
  var obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> adminLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print("Email Entered: $email");
    print("Password Entered: $password");

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      var querySnapshot = await _firestore
          .collection("adminLogin")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        box.write('isLoggedIn', true);
        Get.offAll(() => Dashboard());
        Get.snackbar("Success", "Login Successful",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Invalid credentials!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading(false);
    }
  }
}
