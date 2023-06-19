import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ckc_social_app/app/core/services/firebase_service.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/message/controllers/message_controller.dart';
import 'package:ckc_social_app/app/modules/message/widget/chatcard_widget.dart';

class MessageSettingProfileMembersView extends StatefulWidget {
  const MessageSettingProfileMembersView({super.key});

  @override
  State<MessageSettingProfileMembersView> createState() => _MessageSettingProfileMembersViewState();
}

class _MessageSettingProfileMembersViewState<T extends MessageController> extends State<MessageSettingProfileMembersView>
    with TickerProviderStateMixin {
  late final Map<Widget, Widget> tabBarWidget;
  late final TabController tabBarController;
  late final FireBaseService fireBaseService;
  late final T controller;
  late final ValueNotifier<List<UsersModel>> listMemberSelected;

  @override
  void initState() {
    super.initState();
    controller = Get.find<T>();
    fireBaseService = Get.find<FireBaseService>();
    listMemberSelected = ValueNotifier<List<UsersModel>>([]);
    tabBarWidget = {
      const Tab(text: 'Tất cả'): MessageSettingProfileMembersTabAllWidget(listMemberSelected: listMemberSelected),
      const Tab(text: 'Quản trị viên'): const MessageSettingProfileMembersTabAdminWidget(),
    };

    tabBarController = TabController(length: tabBarWidget.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // extendBody: true,
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true, //giuu lau bottom
              pinned: true, //giuu lai bottom
              snap: true,

              title: const Text('Thành viên'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () => controller.onAddMemberToGroupMessage<T>(context: context, listMemberSelected: listMemberSelected),
                    child: const Text('Thêm'),
                  ),
                )
              ],
              bottom: TabBar(
                controller: tabBarController,
                tabs: tabBarWidget.keys.toList(),
                indicatorColor: Theme.of(context).colorScheme.secondary,
                // indicatorSize: TabBarIndicatorSize.label,
                //duong` vien`
                indicatorPadding: const EdgeInsets.all(8),
                splashBorderRadius: BorderRadius.circular(100),
                indicator: ShapeDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          body: TabBarView(
            controller: tabBarController,
            children: tabBarWidget.values.toList(),
          ),
        ),
      ),
    );
  }
}

class MessageSettingProfileMembersTabAllWidget extends StatelessWidget {
  const MessageSettingProfileMembersTabAllWidget({super.key, required this.listMemberSelected});

  final ValueNotifier<List<UsersModel>> listMemberSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageController>();
    final fireBaseService = Get.find<FireBaseService>();
    return StreamBuilder(
        stream: fireBaseService.call_getChatRoomDocs(controller.currentChatRoom['chatRoomId']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UsersModel> members = List<Map<String, dynamic>>.from(snapshot.data!['members']).map((e) => UsersModel().fromJson(e)).toList();
            listMemberSelected.value = members;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: members.length,
              itemBuilder: (context, index) {
                return ChatCard(
                  user: members[index],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class MessageSettingProfileMembersTabAdminWidget extends StatelessWidget {
  const MessageSettingProfileMembersTabAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final fireBaseService = context.read<FireBaseService>();
    return Container();
  }
}
