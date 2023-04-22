import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({super.key, required this.radius, this.image});

  final double radius;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: StringExtension.randomString(10),
      child: CircleAvatar(
          radius: radius,
          backgroundImage: (image?.contains('assets') ?? false) ? AssetImage(image ?? 'assets/images/user_default_icon.png') : null,
          child: //check image is web url
              image?.contains('http') ?? true
                  ? ClipOval(
                      child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/user_default_icon.png',
                      image: image ??
                          'https://img.freepik.com/free-vector/cute-bad-cat-wearing-suit-sunglasses-with-baseball-bat-cartoon-icon-illustration-animal-fashion-icon-concept-isolated-flat-cartoon-style_138676-2170.jpg?w=2000',
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 180),
                    )

                      // return Image.network(
                      //   listImage[Random().nextInt(listImage.length)]["icon"],
                      //   fit: BoxFit.cover,
                      //   loadingBuilder: (context, child, loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         value: loadingProgress.expectedTotalBytes != null
                      //             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      //             : null,
                      //       ),
                      //     );
                      //   },
                      // );

                      )
                  : null),
    );
  }
}
