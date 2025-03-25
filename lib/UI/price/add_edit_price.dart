import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Controller/price_controller.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';

class PriceFormPage extends StatelessWidget {
  final PriceListController controller = Get.find<PriceListController>();
  final String? docId;
  final Map<String, dynamic>? data;

  PriceFormPage({this.docId, this.data}) {

    controller.setData(data);
    print("Retrieved category ddd: ${  controller.selectedCategory.value}");
    if (data != null) {

      controller.nameController.text = data!['name'] ?? '';
      controller.prasadhamNameTamilController.text = data!['name_tamil'] ?? '';
      controller.noteEnglishController.text = data!['unit'] ?? '';
      controller.noteTamilController.text = data!['unit_tamil'] ?? '';
      controller.descriptionEnglishController.text = data!['name'] ?? '';
      controller.descriptionTamilController.text = data!['name_tamil'] ?? '';
      controller.amountController.text = data!['amount']?.toString() ?? '';
    } else {
      controller.selectedCategory.value = 'Prasadham';
      controller.nameController.clear();
      controller.prasadhamNameTamilController.clear();
      controller.noteEnglishController.clear();
      controller.noteTamilController.clear();
      controller.descriptionEnglishController.clear();
      controller.descriptionTamilController.clear();
      controller.amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return      Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCard(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value,
                    items: ['Prasadham', 'Abishegam']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => controller.setCategory(value!),
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ))),
              SizedBox(height: 15),
              Obx(() {
                return Column(
                  children: [
                    if (controller.selectedCategory.value == 'Prasadham') ...[
                      _buildCard(child: _buildTextField(controller.nameController, 'Prasadham Name')),
                      _buildCard(child: _buildTextField(controller.prasadhamNameTamilController, 'Prasadham Name (Tamil)')),
                      _buildCard(child: _buildTextField(controller.noteEnglishController, 'Note', maxLines: 2)),
                      _buildCard(child: _buildTextField(controller.noteTamilController, 'Note (Tamil)', maxLines: 2)),

                      _buildCard(child: _buildTextField(controller.amountController, 'Amount', isNumber: true)),
                    ],
                    if (controller.selectedCategory.value == 'Abishegam') ...[
                      _buildCard(child: _buildTextField(controller.descriptionEnglishController, 'Description', maxLines: 2)),
                      _buildCard(child: _buildTextField(controller.descriptionTamilController, 'Description (Tamil)', maxLines: 2)),
                      _buildCard(child: _buildTextField(controller.amountController, 'Amount', isNumber: true)),
                    ],
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (docId == null) {
                          controller.addOrUpdatePrice();
                        } else {
                          controller.addOrUpdatePrice(docId: docId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
