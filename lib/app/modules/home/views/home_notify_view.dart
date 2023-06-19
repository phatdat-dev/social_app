import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/home/widget/facebook_card_notification.dart';
import 'package:ckc_social_app/app/modules/notification/controllers/notification_controller.dart';

import '../../user/widget/user_friend_card_widget.dart';

class HomeNotifyView extends StatefulWidget {
  HomeNotifyView({Key? key}) : super(key: key);

  @override
  _HomeNotifyViewState createState() => _HomeNotifyViewState();
}

class _HomeNotifyViewState extends State<HomeNotifyView> {
  final notificationController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Những người bạn có thể biết',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        UserFriendCardWidget(
          title: 'Wung Chang',
        ),
        // ElevatedButton(onPressed: () {}, child: Text("See All")),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Trước đó',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        notificationController.listNotification.obx((state) => ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state == null ? 0 : state.length,
            itemBuilder: (context, int index) {
              final item = state![index];
              return FacebookCardNotification(
                color: item['status'] == 'unread' ? Theme.of(context).colorScheme.secondary : null,
                ImageData: item['userAvatarFrom'],
                title: item['userNameFrom'] + ' ' + item['title'],
                date: DateTime.tryParse(item['created_at'] ?? '')?.timeAgoSinceDate() ?? '',
                icon: item['notication_type'] == 'page' ? 'assets/images/page.jpg' : 'assets/images/fb.png',
              );
            })),
      ],
    );
  }
}
