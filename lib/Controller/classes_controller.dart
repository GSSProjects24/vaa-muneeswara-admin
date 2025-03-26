import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import 'package:vaa_muneeswara_admin/UI/Comman%20Widget/Button.dart';

import '../Style and Color/font_style.dart';
import '../UI/Comman Widget/alert_box.dart';

class ClassesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController documentController = TextEditingController();
  final RxList<Tab> tabs = <Tab>[].obs;
  final RxList<Widget> tabViews = <Widget>[].obs;

  @override
  void onInit() {
    fetchClasses();
    super.onInit();
  }

  void fetchClasses() async {
    tabs.clear();
    tabViews.clear();

    QuerySnapshot querySnapshot = await _firestore.collection('Classes').get();
    for (var doc in querySnapshot.docs) {
      tabs.add(Tab(text: doc.id));
      tabViews.add(buildTabContent(doc));
    }
  }

  Widget buildTabContent(DocumentSnapshot doc) {
    return FutureBuilder(
      future: doc.reference.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.4, // Adjust the card size
                ),
                itemCount: data.entries.length,
                itemBuilder: (context, index) {
                  var entry = data.entries.elementAt(index);
                  return Card(
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var field in [
                            'class_name',
                            'day',
                            'day_tam',
                            'room',
                            'time',
                            'time_list'
                          ])
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _fieldNames[field]!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                  child: Text(
                                    entry.value[field].toString(),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent overflow
                                  ),
                                ),
                              ],
                            ),
                          Spacer(), // Push button to bottom
                          Align(
                            alignment: Alignment.centerRight,
                            child: Button(
                              buttonText: 'Delete',
                              onPressed: () {
                                print(
                                    'entry.key ${entry.key} document id ${doc.id}');
                                CustomAlertBox.show(
                                  context,
                                  title: 'Delete',
                                  description:
                                      'Are you sure you want to delete this Class?',
                                  okButtonText: "Delete",
                                  onOkPressed: () {
                                    _deleteField(doc.id, entry.key);
                                  },
                                );
                              },
                              backgroundColor: Colors.red.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: ListView(
            //     children: data.entries.map((entry) {
            //       return Card(
            //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //         child: Padding(
            //           padding: EdgeInsets.all(10),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               for (var field in [
            //                 'class_name',
            //                 'day',
            //                 'day_tam',
            //                 'room',
            //                 'time',
            //                 'time_list'
            //               ])
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       _fieldNames[field]!,
            //                       style: TextStyle(fontWeight: FontWeight.bold),
            //                     ),
            //                     Text(entry.value[field].toString()),
            //                   ],
            //                 ),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: ElevatedButton.icon(
            //                   onPressed: () {
            //                     print(
            //                         'entry.key ${entry.key} document id ${doc.id}');
            //                     CustomAlertBox.show(context,
            //                         title: 'Delete',
            //                         description:
            //                         'Are you sure want to Delete this Classe?',
            //                         okButtonText: "Delete", onOkPressed: () {
            //                           _deleteField(doc.id, entry.key);
            //                         });
            //
            //                   },
            //                   icon: Icon(Icons.delete, color: Colors.white),
            //                   label: Text("Delete"),
            //                   style: ElevatedButton.styleFrom(
            //                       backgroundColor: Colors.red),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      CustomAlertBox.show(context,
                          title: 'Delete',
                          description:
                              'Are you sure want to Delete this All Classes?',
                          okButtonText: "Delete", onOkPressed: () {
                        deleteDocument(doc.id);
                      });
                    },
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.white,
                    ),
                    label: Text("Delete",
                        style: TextStyles.textStyle(14, AppTheme.whiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showAddClassPopup(context, doc.id),
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    label: Text("Add Class",
                        style: TextStyles.textStyle(14, AppTheme.whiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () => showAddClassPopup(context, doc.id),
                  //   child: Text("Add Class"),
                  // ),
                  // SizedBox(width: 10,),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     CustomAlertBox.show(context,
                  //         title: 'Delete',
                  //         description:
                  //             'Are you sure want to Delete this All Classes?',
                  //         okButtonText: "Delete", onOkPressed: () {
                  //       deleteDocument(doc.id);
                  //     });
                  //   },
                  //   child: Text("Delete Document"),
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  final Map<String, String> _fieldNames = {
    'class_name': 'Class Name',
    'day': 'Day',
    'day_tam': 'Day (Tamil)',
    'room': 'Room',
    'time': 'Session',
    'time_list': 'Time',
  };
  void showAddClassPopup(BuildContext context, String documentName) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController classNameController = TextEditingController();
    TextEditingController dayController = TextEditingController();
    TextEditingController dayTamController = TextEditingController();
    TextEditingController roomController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController timeListController = TextEditingController();

    Get.defaultDialog(
      title: "Add Class",
      titleStyle: TextStyles.textStyle(20, AppTheme.primaryColor),
      content: Form(
        key: _formKey, // Form key for validation
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTextField(classNameController, "Class Name"),
              _buildTextField(dayController, "Day"),
              _buildTextField(dayTamController, "Day (Tamil)"),
              _buildTextField(roomController, "Room"),
              _buildTextField(timeController, "Time"),
              _buildTextField(
                  timeListController, "Time List (comma separated)"),
            ],
          ),
        ),
      ),
      confirm: Button(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addClasss(
              documentName,
              classNameController.text.trim(),
              dayController.text.trim(),
              dayTamController.text.trim(),
              roomController.text.trim(),
              timeController.text.trim(),
              timeListController.text.trim(),
            );
            Get.back();
          }
        },
        buttonText: "Submit",
      ),
      // textConfirm: "Submit",
      // onConfirm: () {
      //   if (_formKey.currentState!.validate()) {
      //     addClasss(
      //       documentName,
      //       classNameController.text.trim(),
      //       dayController.text.trim(),
      //       dayTamController.text.trim(),
      //       roomController.text.trim(),
      //       timeController.text.trim(),
      //       timeListController.text.trim(),
      //     );
      //     Get.back();
      //   }
      // },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyles.textStyle(12, AppTheme.black),
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  // void showAddClassPopup(BuildContext context, String documentName) {
  //   TextEditingController classNameController = TextEditingController();
  //   TextEditingController dayController = TextEditingController();
  //   TextEditingController dayTamController = TextEditingController();
  //   TextEditingController roomController = TextEditingController();
  //   TextEditingController timeController = TextEditingController();
  //   TextEditingController timeListController = TextEditingController();
  //
  //   Get.defaultDialog(
  //     title: "Add Class",
  //     content: Column(
  //       children: [
  //         TextField(
  //             controller: classNameController,
  //             decoration: InputDecoration(labelText: "Class Name")),
  //         TextField(
  //             controller: dayController,
  //             decoration: InputDecoration(labelText: "Day")),
  //         TextField(
  //             controller: dayTamController,
  //             decoration: InputDecoration(labelText: "Day (Tamil)")),
  //         TextField(
  //             controller: roomController,
  //             decoration: InputDecoration(labelText: "Room")),
  //         TextField(
  //             controller: timeController,
  //             decoration: InputDecoration(labelText: "Time")),
  //         TextField(
  //             controller: timeListController,
  //             decoration:
  //                 InputDecoration(labelText: "Time List (comma separated)")),
  //       ],
  //     ),
  //     textConfirm: "Submit",
  //     onConfirm: () {
  //       addClasss(
  //           documentName,
  //           classNameController.text.trim(),
  //           dayController.text.trim(),
  //           dayTamController.text.trim(),
  //           roomController.text.trim(),
  //           timeController.text.trim(),
  //           timeListController.text.trim());
  //       Get.back();
  //     },
  //   );
  // }

  Future<void> _deleteField(String documentName, String fieldKey) async {
    try {
      await FirebaseFirestore.instance
          .collection('Classes')
          .doc(documentName) // Correct document reference
          .update({
        fieldKey: FieldValue.delete(), // Delete the entire map key
      });
      fetchClasses();
      print('$fieldKey deleted successfully');
    } catch (e) {
      print('Error deleting field: $e');
    }
  }

  final TextEditingController classNameController = TextEditingController();

  void addClasss(String documentName, String className, String day,
      String dayTam, String room, String time, String timeList) async {
    DocumentSnapshot doc =
        await _firestore.collection('Classes').doc(documentName).get();
    Map<String, dynamic> existingData =
        doc.exists ? doc.data() as Map<String, dynamic> : {};
    int classNumber = 1;

    while (existingData.containsKey('class$classNumber')) {
      classNumber++;
    }

    Map<String, dynamic> newClass = {
      'class_name': className,
      'day': day,
      'day_tam': dayTam,
      'room': room,
      'time': time,
      'session_order': classNumber.toString(),
      'time_list': timeList
    };
    await _firestore
        .collection('Classes')
        .doc(documentName)
        .update({'class$classNumber': newClass});
    // await _firestore.collection('Classes').doc(documentName).update({
    //   'class${DateTime.now().millisecondsSinceEpoch}': newClass
    // });
    fetchClasses();
    classNameController.clear();
  }

  void addDocument() async {
    String docName = documentController.text.trim();

    if (docName.isNotEmpty) {
      await _firestore.collection('Classes').doc(docName).set({});
      fetchClasses();
      documentController.clear();
    }
  }

  void deleteDocument(String documentName) async {
    await _firestore.collection('Classes').doc(documentName).delete();
    fetchClasses();
  }

  void addClass(String documentName, Map<String, dynamic> newClass) async {
    await _firestore.collection('Classes').doc(documentName).update(newClass);
    fetchClasses();
  }
}
