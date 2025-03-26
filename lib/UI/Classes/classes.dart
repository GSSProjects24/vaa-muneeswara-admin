import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/UI/Comman%20Widget/Button.dart';

import '../../Controller/classes_controller.dart';
import '../../Style and Color/app_color.dart';
import '../../Style and Color/font_style.dart';
import '../Comman Widget/snackbar.dart';
import '../Drawer/drawer.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final ClassesController controller = Get.put(ClassesController());
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
              SizedBox(height: 20,),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     color: AppTheme.primaryColor,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Center(
              //       child: Text(
              //         "Timing Settings",
              //         style: TextStyles.textStyle(
              //           20,
              //           AppTheme.whiteColor,
              //           weight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Row(
                children: [
                  Expanded(child:   Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Manage Classes",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),),
                  Expanded(
                    child: TextField(
                      controller: controller.documentController,

                      style: TextStyle(color: AppTheme.primaryColor),
                      decoration: InputDecoration(
                        labelText: "Enter a Day",

                        prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                        labelStyle:TextStyles.textStyle(12, AppTheme.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:  AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color:   AppTheme.primaryColor ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(height:40,child: Button(buttonText: 'Add',  onPressed: () {
                      String docName =
                      controller.documentController.text.trim();

                      if (docName.isEmpty) {
                        Snackbar.showOrangeSnackbar(
                            context, 'Please Enter a Day');
                      } else {
                        controller.addDocument();
                      }
                    }, backgroundColor: AppTheme.primaryColor)),
                  ),

                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Obx(() => DefaultTabController(
                      length: controller.tabs.length,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.whiteColor, // Background color
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 10, // Blur effect
                              offset: Offset(4, 4), // Shadow position (X, Y)
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor, // Background color
                                borderRadius: BorderRadius.circular(10), // Rounded corners

                              ),
                              child: TabBar(
                                // controller: controller.tabs,
                                tabs: controller.tabs,
                                labelColor: Colors.white,
                                unselectedLabelColor:AppTheme.whiteColor,
                                indicator: BoxDecoration(
                                  color: AppTheme.containerBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                              ),
                            ),

                            // TabBar(tabs: controller.tabs),
                            Expanded(
                              child: TabBarView(children: controller.tabViews),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
