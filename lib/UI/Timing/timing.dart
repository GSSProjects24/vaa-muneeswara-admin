import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaa_muneeswara_admin/Color/app_color.dart';
import 'package:vaa_muneeswara_admin/UI/Drawer/drawer.dart';
import 'package:vaa_muneeswara_admin/UI/Timing/widget/sectionCard.dart';
import 'package:vaa_muneeswara_admin/UI/Timing/widget/timeSelectButton.dart';
import 'package:vaa_muneeswara_admin/Controller/timing_controller.dart';

class Timing extends StatelessWidget {
  Timing({super.key});
  final TimingController controller = Get.put(TimingController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Row(
        children: [
          SideDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppTheme.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Timing Settings",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppTheme.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SectionCard(
                      title: "General Timings ",
                      children: [
                        Obx(() => TimeSelectButton(
                          label: 'Morning Time',
                          icon: Icons.wb_sunny_outlined,
                          time: controller.morningTime.value,
                          onPressed: () => controller.pickTime(context, controller.morningTime),
                        )),
                        Obx(() => TimeSelectButton(
                          label: 'Afternoon Time',
                          icon: Icons.wb_cloudy_outlined,
                          time: controller.afternoonTime.value,
                          onPressed: () => controller.pickTime(context, controller.afternoonTime),
                        )),
                        Obx(() => TimeSelectButton(
                          label: 'Evening Time',
                          icon: Icons.nights_stay_outlined,
                          time: controller.eveningTime.value,
                          onPressed: () => controller.pickTime(context, controller.eveningTime),
                        )),
                        Obx(() => TimeSelectButton(
                          label: 'Night Time',
                          icon: Icons.brightness_3_outlined,
                          time: controller.nightTime.value,
                          onPressed: () => controller.pickTime(context, controller.nightTime),
                        )),
                      ],
                    ),

                    const SizedBox(height: 24),
                    SectionCard(
                      title: "Office Timings",
                      children: [
                        Obx(() => TimeSelectButton(
                          label: 'Office Morning Time',
                          icon: Icons.access_time_outlined,
                          time: controller.officeMorningStart.value,
                          onPressed: () => controller.pickTime(context, controller.officeMorningStart),
                        )),
                        const SizedBox(height: 16),
                        Obx(() => TimeSelectButton(
                          label: 'Office Night Time',
                          icon: Icons.access_time_outlined,
                          time: controller.officeNightStart.value,
                          onPressed: () => controller.pickTime(context, controller.officeNightStart),
                        )),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.save_outlined, color: Colors.white),
                          label: const Text(
                            "Save Timings",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: controller.saveTimings,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
