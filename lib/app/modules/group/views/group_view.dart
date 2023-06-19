import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/app/modules/group/widget/group_drawer_widget.dart';
import 'package:ckc_social_app/app/modules/home/widget/input_story_widget.dart';
import 'package:ckc_social_app/app/modules/post/widget/facebook_card_post_widget.dart';

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
            child: CustomScrollView(
              controller: controller.fetchPostByGroupIdController.scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  expandedHeight: 200,
                  flexibleSpace: GestureDetector(
                    onTap: () => controller.redirectToGroupInfomation(context),
                    child: FlexibleSpaceBar(
                      centerTitle: false,
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.currentGroup['group_name'] ?? '',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text.rich(
                            const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.public,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                TextSpan(text: ' Công khai'),
                                TextSpan(
                                  text: ' ☘ 100k thành viên',
                                ),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                          ),
                        ],
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
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
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
                              onPressed: () {},
                              icon: const Icon(Icons.diversity_3),
                              label: const Text('Đã tham gia'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Theme.of(context).colorScheme.inverseSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.person_add),
                              label: const Text('Mời bạn bè'),
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
            ),
          ),
        ),
      ),
    );
  }
}
