import 'package:flutter/material.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import '../../Style and Color/font_style.dart';
import '../Comman Widget/alert_box.dart';
import '../Drawer/drawer.dart';
import 'contact_service.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final ContactFirebase _firestoreService = ContactFirebase();
  final String docId = 'contact';

  Map<String, dynamic>? contactData;
  bool isEditing = false;
  TextEditingController addressController = TextEditingController();
  TextEditingController contactTitleController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController socialMediaTitleController = TextEditingController();
  List<Map<String, String>> phoneList = [];
  List<Map<String, String>> emailList = [];

  @override
  void initState() {
    super.initState();
    fetchContactInfo();
  }

  Future<void> fetchContactInfo() async {
    final data = await _firestoreService.getContactInfo(docId);
    if (data != null) {
      setState(() {
        contactData = data;
        addressController.text = data['address'] ?? '';
        facebookController.text = data['facebook'] ?? '';
        whatsappController.text = data['whatsapp'] ?? '';
        instaController.text = data['insta'] ?? '';
        contactTitleController.text =data['contactTitle']?? '';
        socialMediaTitleController.text = data['socialMediaTitle'] ?? '';

        phoneList = (data['phone'] as Map<String, dynamic>?)
            ?.entries
            .map((e) => {'name': e.key, 'number': e.value.toString()})
            .toList() ??
            [];

        emailList = (data['email'] as Map<String, dynamic>?)
            ?.entries
            .map((e) => {'name': e.key, 'email': e.value.toString()})
            .toList() ??
            [];
      });
    }
  }


  Future<void> updateContactInfo() async {
    final updatedData = {
      'address': addressController.text,
      'facebook': facebookController.text,
      'insta': instaController.text,
      'whatsapp': whatsappController.text,
      'socialMediaTitle': socialMediaTitleController.text,
      'phone': {for (var item in phoneList) item['name']!: item['number']!},
      'email': {for (var item in emailList) item['name']!: item['email']!},
    };

    await _firestoreService.updateContactInfo(docId, updatedData);
    setState(() {
      isEditing = false;
    });

    fetchContactInfo();
  }


  void addPhoneEntry() {
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add Phone",
          style: TextStyle(color:  AppTheme.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: "Phone Number")),
          ],
        ),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              backgroundColor:AppTheme.secondaryColor,
            ),
            onPressed: () {
              setState(() {
                phoneList.add({
                  'name': nameController.text,
                  'number': numberController.text
                });
              });
              updateContactInfo();
              Navigator.pop(context);
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void deletePhoneEntry(int index) {
    setState(() {
      phoneList.removeAt(index);
    });
    updateContactInfo();
  }

  Future<void> updateContactInfo2() async {
    final updatedData = {
      'address': addressController.text,
      'contactTitle': contactTitleController.text,
      'facebook': facebookController.text,
      'whatsapp': whatsappController.text,
      'insta': instaController.text,
      'socialMediaTitle': socialMediaTitleController.text,
    };
    await _firestoreService.updateContactInfo(docId, updatedData);
    fetchContactInfo();
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Contact Info",
          style: TextStyle(color:  AppTheme.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: contactTitleController,
                decoration: InputDecoration(labelText: "Contact Title")),
            TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address")),
            TextField(
                controller: socialMediaTitleController,
                decoration: InputDecoration(labelText: "Social Media Title")),
            TextField(
                controller: facebookController,
                decoration: InputDecoration(labelText: "Facebook")),  TextField(
                controller: whatsappController,
                decoration: InputDecoration(labelText: "Whatsapp")),
            TextField(
                controller: instaController,
                decoration: InputDecoration(labelText: "Instagram")),

          ],
        ),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () {
              updateContactInfo2();
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          SideDrawer(),
          Expanded(
            child: Column(
              children: [
                contactData == null
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppTheme.primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Contact Info",
                                      style: TextStyles.textStyle(20,AppTheme.whiteColor,
                                        weight: FontWeight.bold,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20,  ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Column(
                                  children: [

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton.icon(
                                              onPressed: showEditDialog,
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                "Edit",
                                                style:
                                                    TextStyle(color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:AppTheme.secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          _buildInfoRow(Icons.title, "Contact Title",
                                              contactTitleController.text),
                                          _buildInfoRow(Icons.location_on,
                                              "Address", addressController.text),
                                          _buildInfoRow(Icons.video_library,
                                              "Social Media Title", socialMediaTitleController.text),
                                          _buildInfoRow(Icons.phone, "Whatsapp",
                                              whatsappController.text),  _buildInfoRow(Icons.facebook, "Facebook",
                                              facebookController.text),
                                          _buildInfoRow(Icons.camera_alt,
                                              "Instagram", instaController.text),

                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Phone List",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: addPhoneEntry,
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              "Add Phone",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:AppTheme.secondaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      child: DataTable(
                                        columnSpacing: 20,
                                        headingRowColor: MaterialStateProperty.all(AppTheme.backgroundColor),
                                        border: TableBorder.all(
                                            color: Colors.grey.shade300),
                                        columns: [
                                          DataColumn(
                                            label: Text(
                                              "Name",
                                              style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Phone Number",
                                                style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Actions",
                                                style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                        ],
                                        rows:
                                            phoneList.asMap().entries.map((entry) {
                                          return DataRow(cells: [
                                            DataCell(
                                                Text(entry.value['name'] ?? '')),
                                            DataCell(
                                                Text(entry.value['number'] ?? '')),
                                            DataCell(
                                              Row(
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () => editPhoneEntry(
                                                      entry.key,
                                                      entry.value['name']!,
                                                      entry.value['number']!,
                                                    ),
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      "Edit",
                                                        style: TextStyles.textStyle(14, AppTheme.whiteColor )
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      AppTheme.primaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      CustomAlertBox.show(
                                                        context,
                                                        title: "Delete",
                                                        description: "Are you sure you want to delete this Phone No?",
                                                        okButtonText: "Delete",
                                                        onOkPressed: () {
                                                          deletePhoneEntry(entry.key);
                                                          print('try start ${docId}');
                                                        },
                                                      );
                                                      // DeleteAlert.showDeleteDialog(onConfirm:(){ deletePhoneEntry(entry.key);});
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      "Delete",
                                                        style: TextStyles.textStyle(14, AppTheme.whiteColor )
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red.shade900,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              // IconButton(
                                              //   icon: Icon(Icons.delete, color: Colors.red.shade900),
                                              //   onPressed: () => deletePhoneEntry(entry.key),
                                              // ),
                                            ),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Email List",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: addEmailEntry,
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              "Add Email",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:AppTheme.secondaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20,),
                                    Container(
                                      width: double.infinity,
                                      child: DataTable(
                                        columnSpacing: 20,
                                        headingRowColor: MaterialStateProperty.all(AppTheme.backgroundColor),
                                        border: TableBorder.all(color: Colors.grey.shade300),
                                        columns: [
                                          DataColumn(
                                            label: Text(
                                              "Name",
                                                style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Email",
                                                style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Actions",
                                                style: TextStyles.textStyle(18, AppTheme.black,weight: FontWeight.bold)
                                            ),
                                          ),
                                        ],
                                        rows: emailList.asMap().entries.map((entry) {
                                          return DataRow(cells: [
                                            DataCell(Text(entry.value['name'] ?? '')),
                                            DataCell(Text(entry.value['email'] ?? '')),
                                            DataCell(
                                              Row(
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () => editEmailEntry(
                                                      entry.key,
                                                      entry.value['name']!,
                                                      entry.value['email']!,
                                                    ),
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      "Edit",
                                                        style: TextStyles.textStyle(14, AppTheme.whiteColor )
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppTheme.primaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      CustomAlertBox.show(
                                                        context,
                                                        title: "Delete",
                                                        description: "Are you sure you want to delete this Email ID?",
                                                        okButtonText: "Delete",
                                                        onOkPressed: () {
                                                          deleteEmailEntry(entry.key);
                                                          print('try start ${docId}');
                                                        },
                                                      );

                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      "Delete",
                                                        style: TextStyles.textStyle(14, AppTheme.whiteColor )
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red.shade900,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                        }).toList(),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void deleteEmailEntry(int index) {
    setState(() {
      emailList.removeAt(index);
    });
    updateContactInfo();
  }

  void addEmailEntry() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Email", style: TextStyle(color: AppTheme.primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor:  AppTheme.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () {
              setState(() {
                emailList.add({
                  'name': nameController.text,
                  'email': emailController.text
                });
              });
              updateContactInfo();
              Navigator.pop(context);
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  void editEmailEntry(int index, String currentName, String currentEmail) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Email", style: TextStyle(color: AppTheme.primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor:AppTheme.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () {
              setState(() {
                emailList[index] = {
                  'name': nameController.text,
                  'email': emailController.text,
                };
              });
              updateContactInfo();
              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void editPhoneEntry(int index, String currentName, String currentNumber) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController numberController =
        TextEditingController(text: currentNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Phone",
          style: TextStyle(color:  AppTheme.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: "Number"),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              backgroundColor: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              backgroundColor:AppTheme.secondaryColor,
            ),
            onPressed: () {
              setState(() {
                phoneList[index] = {
                  'name': nameController.text,
                  'number': numberController.text,
                };
              });
              updateContactInfo();
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color:  AppTheme.secondaryColor),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  "$label: $value",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
