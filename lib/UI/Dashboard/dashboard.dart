import 'package:flutter/material.dart';
import 'package:vaa_muneeswara_admin/Color/app_color.dart';

import '../Drawer/drawer.dart';
import 'banner/banner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideDrawer(),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: double.infinity,
            // decoration: BoxDecoration(
            //   border: Border.all(color: AppTheme.primaryColor,width: 2),
            //     borderRadius: BorderRadius.circular(5),
            //     // color: Colors.greenAccent.shade100
            // ),
            child: Column(
              children: [
                WebBanner(),
                Text('home'),
              ],
            ),
          )),
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
