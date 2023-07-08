import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../custom/other/tooltip_shapeborder_custom.dart';
import '../../../routes/app_pages.dart';

class UserAlbumDetailView extends StatefulWidget {
  const UserAlbumDetailView({super.key});

  @override
  State<UserAlbumDetailView> createState() => _UserAlbumDetailViewState();
}

class _UserAlbumDetailViewState extends State<UserAlbumDetailView> {
  late final UserController controller;
  late final Map<
      String,
      ({
        Color? iconColor,
        Icon icon,
        VoidCallback onTap,
      })> builderActionAppBar;

  @override
  void initState() {
    super.initState();
    final userId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
    final int albumId = int.tryParse(Get.parameters['albumId'] ?? '') ?? 0;

    controller = Get.find<UserController>(tag: '${userId}');
    controller.call_fetchImageFromAlbum(userId: userId, albumId: albumId);

    builderActionAppBar = {
      LocaleKeys.EditAlbum: (
        iconColor: Colors.amber,
        icon: const Icon(Icons.edit_outlined),
        onTap: () => Get.toNamed(Routes.USER_PHOTO_ALBUM_EDITING('${controller.userId}', "${controller.currentAlbum.state!['id']}")),
      ),
      LocaleKeys.DeleteAlbum: (
        iconColor: Colors.red,
        icon: const Icon(Icons.delete_outline),
        onTap: () {},
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: controller.currentAlbum.obx(
            (state) => Text("${state!['album_name']}"),
          ),
          actions: [
            PopupMenuButton(
              //vị trí khi show menu
              offset: const Offset(0, 50),
              shape: const TooltipShapeBorderCustom(),
              //xài child + padding để nó nằm ở góc
              padding: EdgeInsets.zero,
              child: const Icon(Icons.more_horiz),
              onSelected: (value) => builderActionAppBar[value]!.onTap(),
              itemBuilder: (context) => builderActionAppBar.entries
                  .map((e) => PopupMenuItem(
                        padding: EdgeInsets.zero,
                        value: e.key,
                        child: ListTile(
                          iconColor: e.value.iconColor,
                          leading: e.value.icon,
                          title: Text(e.key.tr),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(width: 10),
          ],
        ),
        SliverToBoxAdapter(
          child: controller.currentAlbum.obx(
            (state) => HelperWidget.buildGridViewImage(listData: Helper.convertToListMap(state!['media_files']), fieldName: 'media_file_name'),
          ),
        ),
      ],
    ));
  }
}
