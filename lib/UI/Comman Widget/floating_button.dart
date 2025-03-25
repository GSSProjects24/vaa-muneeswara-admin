import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip; // Tooltip text for hover

  FloatingButton({required this.icon, required this.onPressed, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange], // Gradient Colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip, // Dynamic tooltip
        backgroundColor: Colors.transparent, // Set to transparent
        elevation: 0, // Removes default shadow
        child: Icon(icon, color: Colors.white), // Icon with color
      ),
    );
  }
}
