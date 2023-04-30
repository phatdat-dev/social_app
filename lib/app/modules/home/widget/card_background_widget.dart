import 'package:flutter/material.dart';

class CardBackgroundWidget extends StatelessWidget {
  const CardBackgroundWidget({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorText = Theme.of(context).colorScheme.inversePrimary;
    final String imageUrl = data['avatar'] ?? 'https://i.pinimg.com/originals/81/31/20/8131208cdb98026d71d3f89b8097c522.jpg';
    final String title = data['group_name'] ?? '';
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                width: width,
                height: height,
                image: imageUrl,
                placeholder: 'assets/images/Img_error.png',
                fit: BoxFit.cover,
              ),
            ),
            buildBlurShaderMask(),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(5),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: colorText),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildBlurShaderMask() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.8)],
            stops: [0.75, 1],
          ),
        ),
      );
}
