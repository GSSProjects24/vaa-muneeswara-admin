import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Controller/price_controller.dart';
import 'package:vaa_muneeswara_admin/UI/Drawer/drawer.dart';

class PriceListPage extends StatelessWidget {
  final PriceListController controller = Get.put(PriceListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    "Manage Price List",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Price List Form
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => DropdownButtonFormField<String>(
                            value: controller.selectedCategory.value,
                            items: ['Prasadham', 'Abishegam']
                                .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                                .toList(),
                            onChanged: (value) =>
                                controller.setCategory(value!),
                            decoration: InputDecoration(
                              labelText: 'Select Category',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          )),
                          SizedBox(height: 15),

                          Obx(() {
                            return Column(
                              children: [
                                // Prasadham Fields
                                if (controller.selectedCategory.value == 'Prasadham') ...[
                                  TextFormField(
                                    controller: controller.nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Prasadham Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 15),

                                  TextFormField(
                                    controller: controller.prasadhamNameTamilController,
                                    decoration: InputDecoration(
                                      labelText: 'Prasadham Name (Tamil)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    controller: controller.noteEnglishController,
                                    decoration: InputDecoration(
                                      labelText: 'Note',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    controller: controller.noteTamilController,
                                    decoration: InputDecoration(
                                      labelText: 'Note (Tamil)',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 15),
                                ],

                                // Common Fields (Amount & Description)
                                TextFormField(
                                  controller: controller.amountController,
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 15),

                                TextFormField(
                                  controller: controller.descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 15),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: controller.addOrUpdatePrice,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Price List Section
                  Expanded(child: _buildPriceList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
    );
  }

  Widget _buildPriceList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getPriceList(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data['category'] == 'Prasadham' ? data['name'] ?? '' : ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹${data['amount']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => controller.loadForEdit(
                              docs[index].id, data),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deletePrice(
                              docs[index].id),
                        ),
                      ],
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
}