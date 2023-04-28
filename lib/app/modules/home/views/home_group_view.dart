import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/card_background_widget.dart';

class HomeGroupView extends StatefulWidget {
  @override
  _HomeGroupViewState createState() => _HomeGroupViewState();
}

class _HomeGroupViewState extends State<HomeGroupView> {
  //controller
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.call_fetchGroupJoined();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Pages',
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150,
            child: Builder(builder: (context) {
              final groupData = context.select((HomeController value) => value.groupData);
              return ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  const SizedBox(width: 10),
                  if (groupData?.isNotEmpty ?? false)
                    ...Helper.listGenerateSeparated(
                      groupData!.length,
                      generator: (index) => CardBackgroundWidget(
                        data: groupData[index],
                        width: 150,
                        height: 150,
                      ),
                      separator: (index) => const SizedBox(width: 10),
                    ),
                  const SizedBox(width: 10),
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Your Pages',
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 1)),
                    child: const Center(
                      child: Text(
                        'C',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Column(children: <Widget>[
                  const Text('Cool Teens',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(),
                  )
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
