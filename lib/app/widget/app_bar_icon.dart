
import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;

  AppBarIcon({required this.iconData, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Icon(iconData),
      ),
    );
  }
}
