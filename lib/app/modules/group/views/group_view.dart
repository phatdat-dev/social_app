// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/models/response/privacy_model.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/app/modules/group/widget/group_drawer_widget.dart';
import 'package:ckc_social_app/app/modules/home/widget/input_story_widget.dart';
import 'package:ckc_social_app/app/modules/post/widget/facebook_card_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../search_friend/views/search_tag_friend_view.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  late final GroupController controller;
  late final listChoiceChip = [
    'Bạn',
    'Reals',
    'Đáng chú ý',
    'Ảnh',
    'Sự kiện',
    'File',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<GroupController>();
    controller.call_fetchMemberGroup();
  }

  void onLeaveGroup() async {
    //viết tạm thẳng vào đây cho lẹ, lười tách
    final result = await HelperWidget.showGenericDialog(
      context: context,
      title: 'Rời nhóm',
      content: 'Bạn có muốn rời khỏi nhóm này?',
      optionsBuilder: () => {LocaleKeys.Cancel.tr: false, 'OK': true},
    );
    if (result != null && result) {
      await controller.call_removeMemberFromGroup(
        userId: AuthenticationController.userAccount!.id!,
        groupId: controller.currentGroup['id'],
      );

      //nếu "Rời nhóm thì out màn hình"
      Get.until((route) => route.settings.name == Routes.HOME());
      controller.onInitData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: GetBuilder(
        init: controller.fetchPostByGroupIdController,
        builder: (fetchPostByGroupIdController) => Scaffold(
          resizeToAvoidBottomInset: false,
          // extendBody: true,
          extendBodyBehindAppBar: true,
          drawer: const GroupDrawerWidget(),
          body: RefreshIndicator(
            onRefresh: () async {
              await fetchPostByGroupIdController.onInitData();
            },
            child: Obx(() {
              controller.currentGroup.value;
              return CustomScrollView(
                controller: controller.fetchPostByGroupIdController.scrollController,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: GestureDetector(
                      onTap: () => controller.redirectToGroupInfomation(context),
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        title: LayoutBuilder(
                          builder: (context, constraints) {
                            final Color defaultTitleColor = constraints.maxHeight > 150 ? Colors.white : Colors.black;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.currentGroup['group_name'] ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: defaultTitleColor, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Obx(() {
                                  final lengthMembers = controller.memberGroupData.value.length.formatNumberCompact();
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.public,
                                            color: defaultTitleColor,
                                            size: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${PrivacyModel.from(int.parse(controller.currentGroup['privacy'].toString())).privacyGroupName}',
                                        ),
                                        // memberGroupData.value
                                        TextSpan(text: ' ☘ $lengthMembers thành viên'),
                                        const TextSpan(text: ' >', style: TextStyle(color: Colors.cyan)),
                                      ],
                                    ),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: defaultTitleColor),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                        background: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(controller.currentGroup['avatar']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: [0.5, 1],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    leadingWidth: 100,
                    leading: Builder(builder: (context) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BackButton(),
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(), //(controller.key.currentState as ScaffoldState).openDrawer()
                            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                          ),
                        ],
                      );
                    }),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      if (controller.currentGroup['isAdminGroup'] == true)
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => controller.redirectToGroupEditing(context),
                        ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: onLeaveGroup,
                                icon: const Icon(Icons.diversity_3),
                                label: Text(LocaleKeys.Joined.tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Theme.of(context).colorScheme.inverseSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  controller.call_fetchFriendToInviteGroup(controller.currentGroup['id']);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SearchTagFriendView<GroupController>(title: LocaleKeys.InviteFriendToGroup.tr),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.person_add),
                                label: Text(LocaleKeys.InviteFriend.tr),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(indent: 100, endIndent: 100),
                      SizedBox(
                        height: 35,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: listChoiceChip.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 10),
                            itemBuilder: (context, index) => ActionChip(
                                  label: Text(listChoiceChip[index]),
                                  avatar: index == 0
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            AuthenticationController.userAccount!.avatar!,
                                          ),
                                        )
                                      : null,
                                  onPressed: () {},
                                )),
                      ),
                      const Divider(indent: 100, endIndent: 100),
                      const InputStoryWidget(),
                      //
                      fetchPostByGroupIdController.obx(
                        (state) {
                          return ListView.builder(
                              itemCount: state!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, int index) {
                                return FacebookCardPostWidget(
                                  state[index],
                                );
                              });
                        },
                      ),
                    ]),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
