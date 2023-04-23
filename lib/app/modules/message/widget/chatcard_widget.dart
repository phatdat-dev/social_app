import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/helper_widget.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/models/users_model.dart';

class ChatCard extends StatelessWidget {
  //dang' ly' ra la` truyen` id hoac token gi` do' de sang trang chat se~ query ra.
  //nhung API bi thieu' nen truyen` luon 1 cai'Object sang
  final UsersModel user;
  final String? txtSearch;
  final VoidCallback? onTap;
  const ChatCard({
    Key? key,
    required this.user,
    this.txtSearch,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = Random().nextBool();
    final isSeen = Random().nextBool();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.avatar!),
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
      title: txtSearch != null
          ? RichText(
              text: TextSpan(
                  children: HelperWidget.highlightOccurrences(user.displayName!, txtSearch!),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            )
          : Text(
              user.displayName!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
      subtitle: Text(
        user.address ?? '', //last message
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
}
