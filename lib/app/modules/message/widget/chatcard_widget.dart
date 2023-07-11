import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final ({String title, String avatar, String? subTitle}) user;
  final String? txtSearch;
  final VoidCallback? onTap;
  const ChatCard({
    Key? key,
    this.txtSearch,
    this.onTap,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSeen = false; //Random().nextBool();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      leading: buildAvatar(),
      title: txtSearch != null
          ? RichText(
              text: TextSpan(
                  children: HelperWidget.highlightOccurrences(user.title, txtSearch!),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            )
          : Text(
              user.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
      subtitle: Text(
        user.subTitle ?? '', //last message
        maxLines: 1,
        overflow: TextOverflow.ellipsis, //text dai` qua' thi` ...
        style: isSeen ? TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold) : null,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateTime.parse('2022-03-31').timeAgoSinceDate(),
            style: const TextStyle(color: Colors.grey),
          ),
          if (isSeen)
            Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                child: const Text('2', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget buildAvatar([double radius = 25]) => Builder(builder: (context) {
        final isActive = false; //Random().nextBool();

        return InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: NetworkImage(user.avatar),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    //neu dang hoat dong thi` them cai bo tron` nho? nho?
                    color: isActive ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                  ),
                ),
              )
            ],
          ),
        );
      });
}
