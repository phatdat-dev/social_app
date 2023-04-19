import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/facebook/components/facebook_card_notification.dart';

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
            "Những người bạn có thể biết",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage('assets/images/china.jpg'), fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Wung Chang",
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            "15 Mutual friends",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            //Add Friends
                            FilledButton.tonal(
                              onPressed: () {},
                              child: Text("Add Friends",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inverseSurface,
                                  )),
                            ),

                            const SizedBox(width: 10),

                            //Remove
                            OutlinedButton(
                              onPressed: () {},
                              child: Text("Remove",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.inverseSurface,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ElevatedButton(onPressed: () {}, child: Text("See All")),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Trước đó",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        FutureBuilder(
            future: Helper.readFileJson("assets/json/notification.json"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return FacebookCardNotification(
                        color: snapshot.data[index]['status'] == "unread" ? Theme.of(context).colorScheme.secondary : null,
                        ImageData: snapshot.data[index]['profile_image'],
                        title: snapshot.data[index]['notification_message'],
                        date: snapshot.data[index]['notification_time'],
                        icon: snapshot.data[index]['notication_type'] == "page" ? 'assets/images/page.jpg' : 'assets/images/fb.png',
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ],
    );
  }
}
