import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListController extends GetxController {
  var selectedCategory = 'Prasadham'.obs;
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();
  final TextEditingController prasadhamNameTamilController = TextEditingController();
  final TextEditingController noteTamilController = TextEditingController();
  final TextEditingController noteEnglishController = TextEditingController();

  // Fetch price list from Firestore
  Stream<QuerySnapshot> getPriceList() {
    return FirebaseFirestore.instance.collection("price_list").snapshots();
  }

  // Set category selection
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Add or Update Price Item
  void addOrUpdatePrice() async {
    if (amountController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar("Error", "Amount and Description are required!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Map<String, dynamic> priceData = {
      "amount": amountController.text,
      "description": descriptionController.text,
      "category": selectedCategory.value,
    };

    if (selectedCategory.value == "Prasadham") {
      if (nameController.text.isEmpty) {
        Get.snackbar("Error", "Prasadham Name is required!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      priceData["name"] = nameController.text;
    }

    try {
      await FirebaseFirestore.instance.collection("price_list").add(priceData);
      Get.snackbar("Success", "Price item saved successfully!",
          snackPosition: SnackPosition.BOTTOM);
      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Failed to save price item: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Load data for editing
  void loadForEdit(String docId, Map<String, dynamic> data) {
    selectedCategory.value = data["category"];
    amountController.text = data["amount"];
    descriptionController.text = data["description"];
    if (selectedCategory.value == "Prasadham") {
      nameController.text = data["name"] ?? "";
    }
  }

  // Delete price item
  void deletePrice(String docId) async {
    await FirebaseFirestore.instance.collection("price_list").doc(docId).delete();
    Get.snackbar("Deleted", "Price item removed",
        snackPosition: SnackPosition.BOTTOM);
  }

  // Clear form fields
  void clearFields() {
    nameController.clear();
    amountController.clear();
    descriptionController.clear();
  }
}
