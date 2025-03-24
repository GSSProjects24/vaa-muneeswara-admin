import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';

class SideDrawer extends StatelessWidget {
  final SideDrawerController controller = Get.put(SideDrawerController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.indigo[900], // Dark blue background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Shopper",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),

          // Menu Items with Navigation
          _buildMenuItem(Icons.dashboard, "Dashboard", 0, Dashboard()),
          _buildMenuItem(Icons.trending_up, "Marketing Report", 1, Dashboard2()),
          _buildMenuItem(Icons.shopping_cart, "Order Summary", 2, Dashboard2()),
          _buildMenuItem(Icons.bar_chart, "Sales Report", 3, Dashboard2()),
          _buildMenuItem(Icons.person, "Profile", 4, Dashboard2()),
          _buildMenuItem(Icons.settings, "Settings", 5, Dashboard2()),
          _buildMenuItem(Icons.logout, "Sign Out", 6, Dashboard2()),

          Spacer(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index, Widget page) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.changePage(index);
        Get.offAll(() => page, transition: Transition.fadeIn);
        // Smooth transition
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: controller.selectedIndex.value == index ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: controller.selectedIndex.value == index ? Colors.blue : Colors.grey,
              radius: 18,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: controller.selectedIndex.value == index ? Colors.indigo[900] : Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}



class SideDrawerController extends GetxController {
  var selectedIndex = 0.obs; // Observable index for menu selection

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
