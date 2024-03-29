// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/models/response/privacy_model.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupInfomationView extends StatefulWidget {
  const GroupInfomationView({super.key});

  @override
  State<GroupInfomationView> createState() => _GroupInfomationViewState();
}

class _GroupInfomationViewState extends State<GroupInfomationView> {
  late final GroupController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<GroupController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(controller.currentGroup['group_name']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Text('Giới thiệu', style: Theme.of(context).textTheme.titleLarge),
          Text(controller.currentGroup['description'] ?? ''),
          Builder(builder: (context) {
            final privacyModel = PrivacyModel.from(int.parse(controller.currentGroup['privacy']));
            return ListTile(
              // contentPadding: EdgeInsets.zero,
              leading: Icon(privacyModel.privacyIcon),
              title: Text(privacyModel.privacyGroupName ?? ''),
              subtitle: Text(privacyModel.privacyGroupDescription ?? ''),
            );
          }),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thành viên', style: Theme.of(context).textTheme.titleLarge),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: () => controller.redirectToGroupMembers(context),
                  icon: const Icon(Icons.navigate_before_outlined),
                  label: const Text('Xem tất cả'),
                ),
              )
            ],
          ),
          SizedBox(
            height: 50,
            child: ObxValue((memberGroupData) {
              if (memberGroupData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(
                children: List.generate(
                  memberGroupData.length,
                  (index) => Positioned(
                    left: index * 25,
                    child: InkWell(
                      onTap: () {
                        //view profile here
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundImage: NetworkImage(memberGroupData[index]['avatar']),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, controller.memberGroupData),
          ),
          const Divider(),
          Text('Hoạt động trong nhóm', style: Theme.of(context).textTheme.titleLarge),
          const ListTile(
            leading: Icon(Icons.forum_outlined),
            title: Text('... bài viết mới hôm nay'),
            subtitle: Text('... bài viết trong ... tháng qua'),
          ),
          Obx(
            () {
              final lengthMembers = controller.memberGroupData.value.length.formatNumberCompact();
              return ListTile(
                leading: const Icon(Icons.groups_3_outlined),
                title: Text('Tổng số thành viên: $lengthMembers'),
                subtitle: const Text('+... trong tháng qua'),
              );
            },
          ),
          Builder(builder: (context) {
            final createdAt = DateTime.parse(controller.currentGroup['created_at']);
            return ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text('Tạo ra từ: ${createdAt.timeAgoSinceDate()}'),
            );
          }),
        ],
      ),
    );
  }
}
