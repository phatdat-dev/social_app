import 'package:flutter/material.dart';

class FacebookButtonNotify extends StatelessWidget {
  final String text;
  final Color color;
  final Color tcolor;
  final VoidCallback onPress;
  final double? width;

  FacebookButtonNotify({required this.text, required this.color, required this.tcolor, required this.onPress, this.width});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
