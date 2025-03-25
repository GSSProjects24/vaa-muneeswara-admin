import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DashboardController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var imageList = <String>[].obs;
  var imageUrl = Rxn<String>(); // Nullable reactive variable

  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }

  void fetchImages() async {
    QuerySnapshot snapshot = await _firestore.collection('homeSlider').get();
    imageList.value =
        snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
  }

  Future<void> pickImage() async {
    try {
      if (GetPlatform.isWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          Uint8List? fileBytes = result.files.first.bytes;
          String fileName = result.files.first.name;

          if (fileBytes == null) {
            Get.snackbar('Error', 'Invalid image file. Please try again.');
            return;
          }

          imageUrl.value = null;

          // Upload fileBytes to Firebase Storage
          Reference ref = _storage.ref().child('homeSlider/$fileName');
          await ref.putData(fileBytes);
          imageUrl.value = await ref.getDownloadURL();
        }
      } else {
        final ImagePicker picker = ImagePicker();
        XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          imageUrl.value = null;

          String fileName = pickedFile.name;
          Reference ref = _storage.ref().child('homeSlider/$fileName');
          await ref.putFile(imageFile);
          imageUrl.value = await ref.getDownloadURL();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image. Please try again.');
    }
  }

  Future<void> saveItem() async {
    if (imageUrl.value == null || imageUrl.value!.isEmpty) {
      return;
    }

    Uri uri = Uri.parse(imageUrl.value!);
    String imageName = uri.pathSegments.last;

    final data = {'imageUrl': imageUrl.value, 'image': imageName};

    await _firestore.collection('homeSlider').add(data);
    fetchImages(); // Refresh list after saving
  }

  Future<void> deleteImage(String docId, String imageUrl) async {
    try {
      await _firestore.collection('homeSlider').doc(docId).delete();
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      fetchImages();
      Get.snackbar('Deleted', 'Image removed successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
