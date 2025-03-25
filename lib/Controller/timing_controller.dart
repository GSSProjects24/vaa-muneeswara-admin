import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var morningTime = Rxn<TimeOfDay>();
  var afternoonTime = Rxn<TimeOfDay>();
  var eveningTime = Rxn<TimeOfDay>();
  var nightTime = Rxn<TimeOfDay>();
  var officeMorningStart = Rxn<TimeOfDay>();
  var officeNightStart = Rxn<TimeOfDay>();

  @override
  void onInit() {
    super.onInit();
    fetchTimings();
  }

  @override
  void onClose() {
    super.onClose();
    clearUnsavedChanges();
  }


  Future<void> pickTime(BuildContext context, Rxn<TimeOfDay> time) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      time.value = picked;
    }
  }


  Future<void> saveTimings() async {
    try {
      await _firestore.collection("timings").doc("schedule").set({
        "morningTime": morningTime.value?.format(Get.context!) ?? "",
        "afternoonTime": afternoonTime.value?.format(Get.context!) ?? "",
        "eveningTime": eveningTime.value?.format(Get.context!) ?? "",
        "nightTime": nightTime.value?.format(Get.context!) ?? "",
        "officeMorningStart": officeMorningStart.value?.format(Get.context!) ?? "",
        "officeNightStart": officeNightStart.value?.format(Get.context!) ?? "",
      });

      Get.snackbar("Success", "Timings saved successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to save timings: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  Future<void> fetchTimings() async {
    try {
      DocumentSnapshot doc = await _firestore.collection("timings").doc("schedule").get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        morningTime.value = _parseTime(data["morningTime"]);
        afternoonTime.value = _parseTime(data["afternoonTime"]);
        eveningTime.value = _parseTime(data["eveningTime"]);
        nightTime.value = _parseTime(data["nightTime"]);
        officeMorningStart.value = _parseTime(data["officeMorningStart"]);
        officeNightStart.value = _parseTime(data["officeNightStart"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch timings: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  void clearUnsavedChanges() {
    morningTime.value = null;
    afternoonTime.value = null;
    eveningTime.value = null;
    nightTime.value = null;
    officeMorningStart.value = null;
    officeNightStart.value = null;
  }


  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    final RegExp timePattern = RegExp(r"(\d{1,2}):(\d{2}) (AM|PM)");
    final match = timePattern.firstMatch(timeString);

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      if (period == "PM" && hour != 12) {
        hour += 12;
      } else if (period == "AM" && hour == 12) {
        hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }
}
