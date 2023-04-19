import 'package:flutter/material.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';

class HomeMenuView extends StatefulWidget {
  HomeMenuView({Key? key}) : super(key: key);

  @override
  _HomeMenuViewState createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView> {
  List<Map<String, dynamic>> items = [
    {
      "image": "assets/images/page.jpg",
      "title": "Your 1 Page",
    },
    {
      "image": "assets/images/bookmarks.png",
      "title": "Bookmark",
    },
    {
      "image": "assets/images/events.png",
      "title": "Events",
    },
    {
      "image": "assets/images/friends.png",
      "title": "Friends",
    },
    {
      "image": "assets/images/memories.png",
      "title": "Memories",
    },
    {
      "image": "assets/images/multimedia.png",
      "title": "Multimedia",
    },
    {
      "image": "assets/images/localization.png",
      "title": "Locals",
    },
    {
      "image": "assets/images/gaming.png",
      "title": "Gaming",
    },
    {
      "image": "assets/images/jobs.png",
      "title": "Jobs",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatarWidget(radius: 30),
          title: Text(
            "Nguyen Van A",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Xem trang cá nhân của bạn",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
          ),
        ),
        const Divider(),
        Text(
          "Lối tắt của bạn",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          width: double.infinity,
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => Column(
              children: [
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          // image: DecorationImage(image: NetworkImage(ImageData), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 3,
                      right: 3,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          elevation: 1,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              // image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover),
                            ),
                            child: Icon(Icons.group_add),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Group Name",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        Text(
          "Tất cả lối tắt",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          children: List.generate(
              items.length,
              (index) => Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, right: 16, left: 8),
                            child: Image.asset(
                              items[index]["image"],
                              width: 48,
                              height: 48,
                            ),
                          ),
                          Text(
                            items[index]["title"],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ],
    );
  }
}
