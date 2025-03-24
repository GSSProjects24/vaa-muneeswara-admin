import 'package:flutter/material.dart';

import '../Drawer/drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideDrawer(), // Sidebar
          Expanded(child: Container(color: Colors.white,child: Text('home'),)),
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
      body: Row(
        children: [
          SideDrawer(), // Sidebar
          Expanded(child: Container(color: Colors.white,child: Text('homedfdfd'),)),
        ],
      ),
    );
  }
}