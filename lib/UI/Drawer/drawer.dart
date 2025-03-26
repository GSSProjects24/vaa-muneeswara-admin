// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:vaa_muneeswara_admin/Controller/timing_controller.dart';
// import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
// import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';
// import 'package:vaa_muneeswara_admin/UI/Timing/timing.dart';
// import 'package:vaa_muneeswara_admin/UI/gallery/gallery.dart';
// import 'package:vaa_muneeswara_admin/UI/price/price.dart';
//
// import '../Contact/contact.dart';
//
// class SideDrawer extends StatelessWidget {
//   final SideDrawerController controller = Get.put(SideDrawerController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250,
//       color: AppTheme.textColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Image.asset('images/app_logo.png'),
//           ),
//           _buildMenuItem(Icons.dashboard, "Dashboard", 0, Dashboard()),
//           _buildMenuItem(Icons.alarm, "Timing", 1, Timing()),
//           _buildMenuItem(Icons.price_change, "Price", 2, PriceListPage()),
//           _buildMenuItem(Icons.image, "Gallery", 3, Gallery()),
//           _buildMenuItem(Icons.phone, "Contact", 4, Contact()),
//           _buildMenuItem(Icons.logout, "Sign Out", 5, Dashboard2()),
//           Spacer(),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(IconData icon, String label, int index, Widget page) {
//     return Obx(() => GestureDetector(
//           onTap: () {
//             controller.changePage(index);
//             Get.offAll(() => page, transition: Transition.fadeIn);
//             // if (page is Timing) {
//             //   Get.offAll(() => Timing(), transition: Transition.fadeIn);
//             //   Get.find<TimingController>().fetchTimings();
//             // } else {
//             //
//             // }
//           },
//           child: Container(
//             margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
//             padding: EdgeInsets.symmetric(vertical: 12),
//             decoration: BoxDecoration(
//               color: controller.selectedIndex.value == index
//                   ? Colors.white
//                   : Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15),
//                 bottomLeft: Radius.circular(15),
//               ),
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 10),
//                 CircleAvatar(
//                   backgroundColor: controller.selectedIndex.value == index
//                       ? AppTheme.secondaryColor
//                       : AppTheme.primaryColor,
//                   radius: 18,
//                   child: Icon(icon, color: Colors.white, size: 20),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: controller.selectedIndex.value == index
//                         ? AppTheme.textColor
//                         : Colors.grey[400],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vaa_muneeswara_admin/Controller/side_controller.dart';
import 'package:vaa_muneeswara_admin/Controller/timing_controller.dart';
import 'package:vaa_muneeswara_admin/Style%20and%20Color/app_color.dart';
import 'package:vaa_muneeswara_admin/UI/Classes/classes.dart';
import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';
import 'package:vaa_muneeswara_admin/UI/Timing/timing.dart';
import 'package:vaa_muneeswara_admin/UI/gallery/gallery.dart';
import 'package:vaa_muneeswara_admin/UI/price/price.dart';
import '../Authentication/login.dart';
import '../Comman Widget/alert_box.dart';
import '../Contact/contact.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final SideDrawerController controller = Get.put(SideDrawerController());

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppTheme.textColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('images/app_logo.png'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuItem(
                      Icons.dashboard, "Dashboard", 0, Dashboard(), context),
                  _buildMenuItem(Icons.alarm, "Timing", 1, Timing(), context),
                  _buildMenuItem(
                      Icons.price_change, "Price", 2, PriceListPage(), context),
                  _buildMenuItem(Icons.sticky_note_2_rounded, "Classes", 3,
                      Classes(), context),
                  _buildMenuItem(Icons.image, "Gallery", 4, Gallery(), context),
                  _buildMenuItem(Icons.phone, "Contact", 5, Contact(), context),
                  _buildMenuItem(Icons.logout, "Sign Out", 6, null, context),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index, Widget? page,
      BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () {
            if (label == "Sign Out") {
              CustomAlertBox.show(
                context,
                title: "Sign Out",
                description:
                    "Are you sure you want to Sign out this Admin Panel?",
                okButtonText: "Signout",
                onOkPressed: () async {
                  final box = GetStorage();
                  await box.erase(); // Clears all stored data
                  Future.delayed(Duration(milliseconds: 100), () {
                    Get.offAll(() => Login());
                  });
                },
              );
            } else {
              controller.changePage(index);
              Get.offAll(() => page!, transition: Transition.fadeIn);
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: controller.selectedIndex.value == index
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: controller.selectedIndex.value == index
                      ? AppTheme.secondaryColor
                      : AppTheme.primaryColor,
                  radius: 18,
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: controller.selectedIndex.value == index
                        ? AppTheme.textColor
                        : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
