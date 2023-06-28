// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/custom/widget/search_widget.dart';
import 'package:ckc_social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTagFriendView<T extends SearchTagFriendController> extends StatefulWidget {
  const SearchTagFriendView({super.key, required this.title, this.minSelected = 2}) : assert(minSelected > 0);

  final String title;
  final int minSelected;

  @override
  State<SearchTagFriendView> createState() => _SearchTagFriendViewState<T>();
}

class _SearchTagFriendViewState<T extends SearchTagFriendController> extends State<SearchTagFriendView> {
  late final T controller;
  final txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<T>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                final listTagFriend = controller.listFriendOfUser.where((element) => element.isSelected).toList();
                if (listTagFriend.length >= widget.minSelected)
                  return ElevatedButton(
                    onPressed: controller.onPresseSearchTagFriendDone,
                    child: const Text('Xong'),
                  );
                return ElevatedButton(
                  onPressed: () {},
                  child: const Text('Xong', style: TextStyle(color: Colors.grey)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                );
              }),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SearchWidget(
              controller: txtController,
              hintText: 'Tìm kiếm',
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
              onChanged: (value) {
                controller.listFriendOfUser.refresh();
              },
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Đã chọn
            Text('Đã chọn', style: Theme.of(context).textTheme.titleLarge),
            //ListView Horizontal
            Container(
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              child: Obx(() {
                final listTagFriend = controller.listFriendOfUser;
                final getListSelected = listTagFriend.where((element) => element.isSelected).toList();
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: getListSelected.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final item = getListSelected[index];
                    return Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(radius: 25, backgroundImage: NetworkImage(item.avatar!)),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Material(
                                elevation: 1,
                                shape: const CircleBorder(),
                                child: GestureDetector(
                                  onTap: () {
                                    item.isSelected = false;
                                    controller.listFriendOfUser.refresh();
                                  },
                                  child: const CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close, size: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.displayName!,
                          maxLines: 2,
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            Text('Tất cả bạn bè', style: Theme.of(context).textTheme.titleLarge),
            Obx(() {
              final listSearch =
                  controller.listFriendOfUser.where((element) => Helper.containsToLowerCase((element).displayName, txtController.text)).toList();
              return Expanded(
                child: ListView.separated(
                  itemCount: listSearch.length,
                  // shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = listSearch[index];
                    return CheckboxListTile(
                      value: item.isSelected,
                      onChanged: (value) {
                        item.isSelected = value!;
                        controller.listFriendOfUser.refresh();
                      },
                      secondary: CircleAvatar(radius: 25, backgroundImage: NetworkImage(item.avatar!)),
                      title: Text(item.displayName!, style: Theme.of(context).textTheme.bodyLarge),
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
