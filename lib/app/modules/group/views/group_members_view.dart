import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:ckc_social_app/app/custom/widget/search_widget.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../search_friend/views/search_tag_friend_view.dart';

class GroupMembersView extends GetView<GroupController> {
  const GroupMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Map<String, dynamic>>> memberGroupDataSearch = ValueNotifier(controller.memberGroupData);
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0, //shadow
              centerTitle: true,
              title: const Text('Thành viên'),
              actions: [
                AppBarIconWidget(
                  icon: const Icon(Icons.group_add_outlined, color: Colors.green),
                  onPressed: () {
                    controller.call_fetchFriendToInviteGroup(controller.currentGroup['id']);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchTagFriendView<GroupController>(title: LocaleKeys.InviteFriendToGroup.tr),
                      ),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SearchBarWidget(
                    controller: TextEditingController(),
                    hintText: 'Search Anyone',
                    onChanged: (value) {
                      memberGroupDataSearch.value =
                          controller.memberGroupData.where((element) => Helper.containsToLowerCase(element['displayName'], value)).toList();
                    },
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              ValueListenableBuilder(
                valueListenable: memberGroupDataSearch,
                builder: (context, data, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final isAdminGroup = item['isAdminGroup'] == 1;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item['avatar']),
                      ),
                      title: Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: item['displayName'],
                          ),
                          if (isAdminGroup) ...[
                            const WidgetSpan(child: SizedBox(width: 10)),
                            TextSpan(
                                text: 'Quản trị viên',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                )),
                          ]
                        ],
                      )),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.account_circle_outlined),
                                SizedBox(width: 10),
                                Text('Trang cá nhân'),
                              ],
                            ),
                          ),
                          if (controller.currentGroup['isAdminGroup'] == true) ...[
                            if ((AuthenticationController.userAccount!.id != item['user_id']) && !isAdminGroup)
                              const PopupMenuItem(
                                value: 'addMemberToAdminGroup',
                                child: Row(
                                  children: [
                                    Icon(Icons.vpn_key_outlined),
                                    SizedBox(width: 10),
                                    Text('Thăng cấp quản trị viên'),
                                  ],
                                ),
                              ),
                            if ((AuthenticationController.userAccount!.id != item['user_id']) && isAdminGroup)
                              const PopupMenuItem(
                                value: 'removeAdminToGroup',
                                child: Row(
                                  children: [
                                    Icon(Icons.vpn_key_off_outlined),
                                    SizedBox(width: 10),
                                    Text('Xóa quyền quản trị viên'),
                                  ],
                                ),
                              ),
                            if (AuthenticationController.userAccount!.id != item['user_id'])
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.person_remove_outlined),
                                    SizedBox(width: 10),
                                    Text('Xóa khỏi nhóm'),
                                  ],
                                ),
                              ),
                          ],
                          if (AuthenticationController.userAccount!.id == item['user_id'])
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.logout_outlined),
                                  SizedBox(width: 10),
                                  Text('Rời khỏi nhóm'),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) {
                          void refresh() => memberGroupDataSearch.value = List.from(controller.memberGroupData);

                          switch (value) {
                            case 'profile':
                              Get.toNamed(Routes.USER('${item['user_id']}'));
                              break;
                            case 'addMemberToAdminGroup':
                              controller.call_setRoleAdminGroup(userId: item['user_id'], groupId: item['group_id']).then((value) {
                                //
                                item['isAdminGroup'] = 1;
                                refresh();
                              });
                              break;
                            case 'removeAdminToGroup':
                              controller
                                  .call_removeMemberFromGroup(removeAdminGroup: true, userId: item['user_id'], groupId: item['group_id'])
                                  .then((value) {
                                //
                                item['isAdminGroup'] = 0;
                                refresh();
                              });
                              break;
                            case 'delete':
                              controller.call_removeMemberFromGroup(userId: item['user_id'], groupId: item['group_id']).then((value) {
                                //
                                controller.memberGroupData.remove(item);
                                refresh();
                                //nếu "Rời nhóm thì out màn hình"
                                if (AuthenticationController.userAccount!.id == item['user_id']) {
                                  Get.until((route) => route.settings.name == Routes.HOME());
                                  controller.onInitData();
                                }
                              });
                              break;
                            default:
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
