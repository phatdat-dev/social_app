// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/modules/post/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/utils.dart';
import '../../../custom/widget/search_widget.dart';
import '../../home/controllers/home_controller.dart';

class FeelingActivityView extends StatefulWidget {
  const FeelingActivityView({super.key});

  @override
  State<FeelingActivityView> createState() => _FeelingActivityViewState();
}

class _FeelingActivityViewState extends State<FeelingActivityView> {
  late final PostController _postController;
  final ListMapDataState _fetchFellAndActivityPosts = ListMapDataState([]);
  final txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //
    _postController = Get.find<HomeController>().postController;
    _fetchFellAndActivityPosts.run(_postController.call_fetchFellAndActivityPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(LocaleKeys.FeelingActivity.tr),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SearchWidget(
              controller: txtController,
              hintText: 'Tìm kiếm',
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _fetchFellAndActivityPosts.obx((state) => AnimatedBuilder(
              animation: txtController,
              builder: (context, child) {
                final listSearch = state!.where((element) => Helper.containsToLowerCase((element)['icon_name'], txtController.text)).toList();
                return GridView.builder(
                  itemCount: listSearch.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 4,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final item = listSearch.elementAt(index);
                    return InkWell(
                      onTap: () => Navigator.pop(context, item),
                      child: Row(
                        children: [
                          CircleAvatar(backgroundImage: NetworkImage(item['patch'])),
                          const SizedBox(width: 10),
                          Text(item['icon_name'].toString()),
                        ],
                      ),
                    );
                  },
                );
              },
            )),
      ),
    );
  }
}
