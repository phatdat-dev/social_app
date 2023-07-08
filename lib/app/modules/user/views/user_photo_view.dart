// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_project.dart';
import '../../../core/utils/utils.dart';

class UserPhotoView extends StatefulWidget {
  const UserPhotoView({super.key});

  @override
  State<UserPhotoView> createState() => _UserPhotoViewState();
}

class _UserPhotoViewState extends State<UserPhotoView> with TickerProviderStateMixin {
  late final UserController controller;
  late final TabController tabBarController;
  late final List<Map<String, dynamic>> tabBarWidget;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>(tag: '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}');

    tabBarWidget = [
      {
        'Key': LocaleKeys.PhotosWithYourFace,
        'ValueNotifier': controller.listImageFromPostTag,
      },
      {
        'Key': LocaleKeys.PhotosOfYou,
        'ValueNotifier': controller.listImageUploadOfUser,
      },
      {
        'Key': 'Albums',
        'ValueNotifier': controller.listImageUploadOfUser,
      },
    ];

    tabBarController = TabController(length: tabBarWidget.length, vsync: this);

    controller.onInitDataUserImage();
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
        body: RefreshIndicator(
          onRefresh: () async {},
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true, //giuu lau bottom
                pinned: true, //giuu lai bottom
                snap: true,
                title: Text(
                  LocaleKeys.Photo.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                bottom: TabBar(
                  controller: tabBarController,
                  tabs: tabBarWidget.map((e) => Tab(text: (e['Key'] as String).tr)).toList(),
                  isScrollable: true,
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
                  // unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
            body: TabBarView(
              controller: tabBarController,
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    (tabBarWidget[0]['ValueNotifier'] as ListMapDataState).obx(
                      (state) => HelperWidget.buildGridViewImage(
                        listData: state!,
                        fieldName: 'media_file_name',
                      ),
                    ),
                  ],
                ),
                //
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    (tabBarWidget[1]['ValueNotifier'] as ListMapDataState).obx(
                      (state) => HelperWidget.buildGridViewImage(
                        listData: state!,
                        fieldName: 'media_file_name',
                      ),
                    ),
                  ],
                ),
                //
                Builder(builder: (context) {
                  final double padding = 10.0;
                  final double spacing = 5;
                  return ListView(
                    padding: EdgeInsets.all(padding),
                    children: <Widget>[
                      SizedBox(
                        //padding & spacing
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.toNamed(Routes.USER_PHOTO_ALBUM_CREATE('${controller.userId}')),
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(LocaleKeys.CreateAlbum.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.theme.colorScheme.surface,
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),
                      controller.listAlbum.obx((state) => Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: spacing,
                            runSpacing: spacing,
                            children: List.generate(state!.length, (index) {
                              final item = state[index];
                              final widthHeight = context.width / 2 - (padding + spacing + 5.5);
                              final borderRadius = BorderRadius.circular(10);
                              return GestureDetector(
                                onTap: () => Get.toNamed(Routes.USER_PHOTO_ALBUM('${controller.userId}', "${item['id']}")),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                                  child: SizedBox(
                                    width: widthHeight,
                                    height: widthHeight,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: widthHeight - 30,
                                          decoration: BoxDecoration(
                                            borderRadius: borderRadius,
                                            image: DecorationImage(
                                              image: (item['thumnail'] != null
                                                  ? NetworkImage(item['thumnail'])
                                                  : const AssetImage('assets/images/Img_error.png')) as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // child: FadeInImage.assetNetwork(
                                          //   placeholder: 'assets/images/Img_error.png',
                                          //   image: item['thumnail'] ?? '',
                                          //   width: double.infinity,
                                          //   fit: BoxFit.cover,
                                          //   fadeInDuration: const Duration(milliseconds: 200),
                                          //   fadeOutDuration: const Duration(milliseconds: 180),
                                          //   // height: 300,
                                          // ),
                                        ),
                                        Text(item['album_name']),
                                        Text('${(item['media_files'] as List).length} ${LocaleKeys.Photo.tr}', style: context.textTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        //Footer
      ),
    );
  }
}
