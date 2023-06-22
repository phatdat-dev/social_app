import 'package:flutter/material.dart';

class AppBarIconWidget extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final String? tooltip;

  AppBarIconWidget({required this.icon, required this.onPressed, this.tooltip});
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.all(5),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
          child: icon,
        ),
      ),
    );
  }
}
