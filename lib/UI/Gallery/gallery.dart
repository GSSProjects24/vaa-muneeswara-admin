import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';

import '../../Style and Color/app_color.dart';
import '../Comman Widget/Button.dart';
import '../Comman Widget/alert_box.dart';
import '../Comman Widget/floating_button.dart';
import '../Dashboard/banner/banner.dart';
import '../Drawer/drawer.dart';
class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _imageUrl;
  List<String> imageList = [];
  void fetchImages() async {
    QuerySnapshot snapshot = await _firestore.collection('gallery').get();

    setState(() {
      imageList = snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    fetchImages();
  }
  List<String> _imageUrls = [];

  Future<void> _pickImages(Function setDialogState) async {
    try {
      List<String> uploadedUrls = [];

      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true, // Allow multiple selection
        );

        if (result != null && result.files.isNotEmpty) {
          setDialogState(() {
            _imageUrls.clear();
          });

          for (var file in result.files) {
            Uint8List? fileBytes = file.bytes;
            String fileName = file.name;

            if (fileBytes == null) {
              Get.snackbar('Error', 'Invalid image file. Please try again.');
              return;
            }

            Reference ref = _storage.ref().child('gallery/$fileName');
            await ref.putData(fileBytes);
            String imageUrl = await ref.getDownloadURL();
            uploadedUrls.add(imageUrl);
          }

          setDialogState(() {
            _imageUrls = uploadedUrls;
          });
        }
      } else {
        final ImagePicker picker = ImagePicker();
        List<XFile>? pickedFiles = await picker.pickMultiImage(); // Pick multiple images

        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          setDialogState(() {
            _imageUrls.clear();
          });

          for (var pickedFile in pickedFiles) {
            File imageFile = File(pickedFile.path);
            String fileName = pickedFile.name;

            Reference ref = _storage.ref().child('gallery/$fileName');
            await ref.putFile(imageFile);
            String imageUrl = await ref.getDownloadURL();
            uploadedUrls.add(imageUrl);
          }

          setDialogState(() {
            _imageUrls = uploadedUrls;
          });
        }
      }
    } catch (e) {
      print("Error picking file: $e");
      Get.snackbar('Error', 'Failed to pick images. Please try again.');
    }
  }
  Future<void> _saveItem() async {
    if (_imageUrls.isEmpty) {
      return;
    }

    for (String url in _imageUrls) {
      Uri uri = Uri.parse(url);
      String imageName = uri.pathSegments.last;

      // Create a document reference to get the ID
      DocumentReference docRef = _firestore.collection('gallery').doc();

      final data = {
        'id': docRef.id,  // Store the document ID
        'imageUrl': url,  // Store a single URL per document
        'image': imageName,  // Store the corresponding image name
      };

      // Set the data with the document ID
      await docRef.set(data);

      // Print the document ID
      print('Document created with ID: ${docRef.id}');
    }

    setState(() {});
  }

  // Future<void> _saveItem() async {
  //   if (_imageUrls.isEmpty) {
  //     return;
  //   }
  //
  //   for (String url in _imageUrls) {
  //     Uri uri = Uri.parse(url);
  //     String imageName = uri.pathSegments.last;
  //
  //     final data = {
  //       'imageUrl': url,  // Store a single URL per document
  //       'image': imageName,  // Store the corresponding image name
  //     };
  //
  //     DocumentReference docRef = await _firestore.collection('gallery').add(data);
  //
  //     // Print the document ID
  //     print('Document created with ID: ${docRef.id}');
  //   }
  //
  //   setState(() {});
  // }



  void _showAddEditPopup() {
    _imageUrls = [];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Add Images',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  _imageUrls.isNotEmpty
                      ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _imageUrls.map((url) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ImageNetwork(
                             image:  url,
                              width: 100,
                              height: 100,
                              fitWeb: BoxFitWeb.cover,
                            ),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 14,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  _imageUrls.remove(url);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                      : GestureDetector(
                    onTap: () async {
                      await _pickImages(setDialogState);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.grey,
                      ),
                      child: const Icon(
                        Icons.upload,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        buttonText: "Cancel",
                        fontColor: AppTheme.black,
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppTheme.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Button(
                        buttonText: "Submit",
                        onPressed: () async {
                          if (_imageUrls.isNotEmpty) {
                            await _saveItem();
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Please select at least one image before submitting.")),
                            );
                          }
                        },
                        fontColor: AppTheme.black,
                        backgroundColor: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImageGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('gallery').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No images found'));
        }

        var images = snapshot.data!.docs;
        return GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1, // Ensures square-like shape
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            String imagePath = images[index]['image']; // Storage path
            String docId = images[index].id; // Document ID

            return FutureBuilder<String>(
              future: FirebaseStorage.instance.ref(imagePath).getDownloadURL(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                }

                String imageUrl = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // Display the fetched image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ImageNetwork(
                            image: imageUrl,
                            height: 320,
                            width: 320,
                            fitWeb: BoxFitWeb.cover,
                          ),
                        ),

                        // Delete icon positioned at the top-right corner
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              print('try start ${docId} ${imagePath}');
                              CustomAlertBox.show(
                                context,
                                title: "Delete",
                                description: "Are you sure you want to delete this image?",
                                okButtonText: "Delete",
                                onOkPressed: () {

                                  _deleteImage(docId, imagePath);
                                  print('try start ${docId}');
                                },
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              radius: 18,
                              child: Icon(Icons.delete, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


  // Future<void> _deleteImage(String docId, String image) async {
  //   print('try start ${docId}');
  //   try {
  //     print('try start ${docId}');
  //     await _firestore.collection('gallery').doc(docId).delete();
  //
  //     // Delete from Firebase Storage
  //     Reference ref = _storage.refFromURL(image);
  //     await ref.delete();
  //     fetchImages();
  //     Get.snackbar('Deleted', 'Image removed successfully',
  //         snackPosition: SnackPosition.BOTTOM);
  //     print('Image removed successfully');
  //   } catch (e) {
  //     print('error ${e}');
  //     Get.snackbar('Error', 'Failed to delete image: $e',
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }
  Future<void> _deleteImage(String docId, String imagePath) async {
    print('Try start: $docId, $imagePath');
    try {
      // Delete Firestore document
      await _firestore.collection('gallery').doc(docId).delete();

      // Delete from Firebase Storage using path
      Reference ref = _storage.ref().child(imagePath);
      await ref.delete();

      fetchImages();
      Get.snackbar('Deleted', 'Image removed successfully',
          snackPosition: SnackPosition.BOTTOM);
      print('Image removed successfully');
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to delete image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingButton(
        icon: Icons.add_a_photo,
        tooltip: 'Upload Image',
        onPressed: _showAddEditPopup,
      ),

      body: Row(
        children: [
          SideDrawer(),
          Expanded(
            child: Container(

              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(  vertical: 15,horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Gallery",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppTheme.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(child: Container( margin: EdgeInsets.symmetric(  horizontal: 20),child: _buildImageGrid())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}