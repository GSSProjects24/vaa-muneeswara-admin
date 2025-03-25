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
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import '../Comman Widget/alert_box.dart';
import '../Comman Widget/button.dart';
import '../Comman Widget/floating_button.dart';
import '../Drawer/drawer.dart';
import 'banner/banner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _imageUrl;
  List<String> imageList = [];
  void fetchImages() async {
    QuerySnapshot snapshot = await _firestore.collection('homeSlider').get();

    setState(() {
      imageList = snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> _pickImage(Function setDialogState) async {
    try {
      if (kIsWeb) {
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

          setDialogState(() {
            _imageUrl = null;
          });

          // Upload fileBytes to Firebase Storage
          Reference ref = _storage.ref().child('homeSlider/$fileName');
          await ref.putData(fileBytes);
          String imageUrl = await ref.getDownloadURL();

          setDialogState(() {
            _imageUrl = imageUrl;
          });
        }
      } else {
        final ImagePicker picker = ImagePicker();
        XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);

          setDialogState(() {
            _imageUrl = null;
          });

          String fileName = pickedFile.name;
          Reference ref = _storage.ref().child('homeSlider/$fileName');
          await ref.putFile(imageFile);
          String imageUrl = await ref.getDownloadURL();

          setDialogState(() {
            _imageUrl = imageUrl;
          });
        }
      }
    } catch (e) {
      print("Error picking file: $e");
      Get.snackbar('Error', 'Failed to pick image. Please try again.');
    }
  }

  Future<void> _saveItem() async {
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return;
    }

    // Extract the image name and extension from _imageUrl
    Uri uri = Uri.parse(_imageUrl!);
    String imageName =
        uri.pathSegments.last; // Extracts the file name with extension

    final data = {
      'imageUrl': _imageUrl,
      'image': '$imageName', // Construct the required format
    };
    print('image path $imageName');
    await _firestore.collection('homeSlider').add(data);
    setState(() {});
  }

  // Future<void> _saveItem() async {
  //   final data = {
  //     'imageUrl': _imageUrl,
  //   };
  //   await _firestore.collection('homeSlider').add(data);
  //   setState(() {});
  // }

  void _showAddEditPopup() {
    _imageUrl = null;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Use setDialogState for alert box UI updates
            return AlertDialog(
              title: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor, // Background color for title
                  borderRadius:
                      BorderRadius.circular(10), // Rounded only at the top
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Add Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _imageUrl != null
                      ? Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ImageNetwork(
                                image: _imageUrl!,
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
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                onPressed: () async {
                                  await _pickImage(
                                      setDialogState); // Pass setDialogState
                                },
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () async {
                            await _pickImage(
                                setDialogState); // Pass setDialogState
                          },
                          child: Container(
                            width: 80, // Adjust size as needed
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.grey, // Background color
                            ),
                            child: const Icon(
                              Icons.upload,
                              color: AppTheme.primaryColor,
                              size: 40, // Adjust icon size
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Button(
                        buttonText: "Submit",
                        onPressed: () async {
                          if (_imageUrl != null && _imageUrl!.isNotEmpty) {
                            await _saveItem();
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Please select an image before submitting.")),
                            );
                          }
                        },

                        // onPressed: () async {
                        //   await _saveItem();
                        //   Navigator.pop(context);
                        //   setState(() {});
                        // },
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

  // Fetch and Display Images
  Widget _buildImageGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('homeSlider').snapshots(),
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
            String imageUrl = images[index]['imageUrl'];
            String docId = images[index].id; // Get document ID

            return Container(
              decoration: BoxDecoration(
                color: AppTheme.grey,
// border: Border.all(color: AppTheme.primaryColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(15), // Ensures rounded corners
                child: Stack(
                  children: [
                    // Image with proper rounded corners
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ImageNetwork(
                        image: imageUrl,
                        height: 320, // Fill container
                        width: 320, // Fill container
                        fitWeb: BoxFitWeb.cover,
                      ),
                    ),

                    // Delete icon positioned at the top-right corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap :(){
                          CustomAlertBox.show(
                            context,
                            title: "Delete",
                            description: "Are you sure you want to delete this image?",
                            okButtonText: "Delete",
                            onOkPressed: () {
                              _deleteImage(docId, imageUrl);
                            },
                          );

                        },
                        // onTap: () => _deleteImage(docId, imageUrl),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          radius: 18,
                          child:
                              Icon(Icons.delete, color: Colors.white, size: 20),
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
  }

  Future<void> _deleteImage(String docId, String imageUrl) async {
    try {
      // Delete from Firestore
      await _firestore.collection('homeSlider').doc(docId).delete();

      // Delete from Firebase Storage
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

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: WebBanner(),
                  ),
                  Expanded(child: _buildImageGrid()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dashboard2 extends StatefulWidget {
  const Dashboard2({super.key});

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideDrawer(), // Sidebar
          Expanded(
              child: Container(
            color: Colors.white,
            child: Text('homedfdfd'),
          )),
        ],
      ),
    );
  }
}
