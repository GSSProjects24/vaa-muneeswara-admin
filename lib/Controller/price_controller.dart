import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceListController extends GetxController {
  var selectedCategory = 'Prasadham'.obs;

  var amountController = TextEditingController();
  var nameController = TextEditingController();
  var prasadhamNameTamilController = TextEditingController();
  var noteEnglishController = TextEditingController();
  var noteTamilController = TextEditingController();
  var descriptionEnglishController = TextEditingController();
  var descriptionTamilController = TextEditingController();

  CollectionReference get collection => FirebaseFirestore.instance
      .collection(selectedCategory.value == "Prasadham"
      ? "pricePrasadam"
      : "priceAbishegam");

  void addOrUpdatePrice({String? docId}) async {
    Map<String, dynamic> data = {

      "amount": "${amountController.text}",
      if (selectedCategory.value == "Prasadham") ...{
        "name": nameController.text,
        "name_tamil": prasadhamNameTamilController.text,
        "unit": noteEnglishController.text,
        "unit_tamil": noteTamilController.text,
        "priority": 1
      } else ...{
        "name": descriptionEnglishController.text,
        "name_tamil": descriptionTamilController.text,
        "priority": 1
      }
    };

    if (docId == null) {
      DocumentReference docRef = await collection.add(data);
      data["id"] = docRef.id;
      await docRef.set(data);
    } else {
      await collection.doc(docId).update(data);
    }

    Get.back();
  }

  void deletePrice(String docId) async {
    await collection.doc(docId).delete();
  }


  void setCategory(String category) {
    selectedCategory.value = category;
  }


  Stream<QuerySnapshot> getPriceList(String category) {
    String collectionName =
    category == "Prasadham" ? "pricePrasadam" : "priceAbishegam";
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }


  void setData(Map<String, dynamic>? data) {
    if (data != null) {


      amountController.text = data['amount']?.toString() ?? '';

      if (selectedCategory.value == 'Prasadham') {
        nameController.text = data['name'] ?? '';
        prasadhamNameTamilController.text = data['name_tamil'] ?? '';
        noteEnglishController.text = data['unit'] ?? '';
        noteTamilController.text = data['unit_tamil'] ?? '';
      } else {
        descriptionEnglishController.text = data['name'] ?? '';
        descriptionTamilController.text = data['name_tamil'] ?? '';
      }
    } else {

      selectedCategory.value = 'Prasadham';
      amountController.clear();
      nameController.clear();
      prasadhamNameTamilController.clear();
      noteEnglishController.clear();
      noteTamilController.clear();
      descriptionEnglishController.clear();
      descriptionTamilController.clear();
    }
  }

}

