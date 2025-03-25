import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Controller/price_controller.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import 'package:vaa_muneeswara_admin/UI/Drawer/drawer.dart';
import 'package:vaa_muneeswara_admin/UI/price/add_edit_price.dart';

class PriceListPage extends StatelessWidget {
  final PriceListController controller = Get.put(PriceListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Row(
          children: [
            // Sidebar Menu
            SideDrawer(),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Price List",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showPriceDialog();
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text("Add New Price", style: TextStyle(
                              fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        labelColor: AppTheme.secondaryColor,
                        unselectedLabelColor: AppTheme.whiteColor,
                        indicatorColor: AppTheme.secondaryColor,
                        tabs: [
                          Tab(child: Text('Prasadham', style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),),),
                          Tab(child: Text('Abishegam', style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),),)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // TabBar View for displaying data in table format
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPriceTable("Prasadham"),
                          _buildPriceTable("Abishegam"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTable(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getPriceList(category),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor,));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No $category items available."));
        }

        final docs = snapshot.data!.docs;

        return SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
                    (states) =>
                    AppTheme.primaryColor.withOpacity(0.2)),
            border: TableBorder.all(color: Colors.grey.shade300),
            columns: [
              DataColumn(
                  label: Text(
                      category == "Prasadham"
                          ? "Name"
                          : "Description",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor))),
              DataColumn(
                  label: Text("Amount",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor))),
              DataColumn(
                  label: Text("Actions",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor))),
            ],
            rows: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return DataRow(cells: [
                DataCell(Text(data['name'] ?? '')),
                DataCell(Text("${data['amount']}")),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                         _showPriceDialog(data: data, docId: doc.id,category:category);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>  _showDeleteConfirmationDialog(context, doc.id),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                controller.deletePrice(docId);
                Navigator.of(context).pop();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  void _showPriceDialog({String? docId, Map<String, dynamic>? data,String? category}) async {
    Future.delayed(Duration.zero, () async {
      print("dta: ${data}");
      if (data == null) {

        controller.selectedCategory.value = 'Prasadham';
        controller.nameController.clear();
        controller.prasadhamNameTamilController.clear();
        controller.noteEnglishController.clear();
        controller.noteTamilController.clear();
        controller.descriptionEnglishController.clear();
        controller.descriptionTamilController.clear();
        controller.amountController.clear();
      } else {
        controller.selectedCategory.value =category ?? 'Prasadham';
        controller.amountController.text = data['amount']?.toString() ?? '';
        if (controller.selectedCategory.value == "Prasadham") {
          controller.nameController.text = data['name'] ?? '';
          controller.prasadhamNameTamilController.text = data['name_tamil'] ?? '';
          controller.noteEnglishController.text = data['unit'] ?? '';
          controller.noteTamilController.text = data['unit_tamil'] ?? '';
        } else {
          controller.descriptionEnglishController.text = data['name'] ?? '';
          controller.descriptionTamilController.text = data['name_tamil'] ?? '';
        }
      }


      Get.defaultDialog(
        title: docId == null ? "Add Price" : "Edit Price",
        titleStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
        content: SizedBox(
          width: 400,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PriceFormPage(data: data, docId: docId),
              ],
            ),
          ),
        ),
      );
    });
  }
}

