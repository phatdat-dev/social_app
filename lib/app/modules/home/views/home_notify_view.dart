import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_notification.dart';

import '../../user/widget/user_friend_card_widget.dart';

class HomeNotifyView extends StatefulWidget {
  HomeNotifyView({Key? key}) : super(key: key);

  @override
  _HomeNotifyViewState createState() => _HomeNotifyViewState();
}

class _HomeNotifyViewState extends State<HomeNotifyView> {
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
        FutureBuilder(
            future: Helper.readFileJson('assets/json/notification.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return FacebookCardNotification(
                        color: snapshot.data[index]['status'] == 'unread' ? Theme.of(context).colorScheme.secondary : null,
                        ImageData: snapshot.data[index]['profile_image'],
                        title: snapshot.data[index]['notification_message'],
                        date: snapshot.data[index]['notification_time'],
                        icon: snapshot.data[index]['notication_type'] == 'page' ? 'assets/images/page.jpg' : 'assets/images/fb.png',
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ],
    );
  }
}
