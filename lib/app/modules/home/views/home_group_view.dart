import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/modules/group/controllers/group_controller.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/card_background_widget.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';

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
    controller.groupController.onInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 125,
          child: Builder(builder: (context) {
            final groupData = context.select((GroupController value) => value.groupData);
            return ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 10),
                if (groupData?.isNotEmpty ?? false)
                  ...Helper.listGenerateSeparated(
                    groupData!.length,
                    generator: (index) => CardBackgroundWidget(
                      data: groupData[index],
                      width: 125,
                      height: 125,
                    ),
                    separator: (index) => const SizedBox(width: 10),
                  ),
                const SizedBox(width: 10),
              ],
            );
          }),
        ),

        //
        Selector(
          selector: (_, GroupController controller) => controller.dataResponse,
          builder: (context, data, child) {
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, int index) {
                  return FacebookCardPostWidget(data[index]);
                });
          },
        )
      ],
    );
  }
}
