import 'package:ckc_social_app/app/core/services/picker_service.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:ckc_social_app/generated/locales.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEditingView extends GetView<UserController> {
  const UserEditingView({super.key});

  @override
  String? get tag => '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.UpdateMyProfile.tr)),
      body: SafeArea(
          child: controller.obx((state) => ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GetBuilder(
                            init: PickerService(),
                            tag: LocaleKeys.ProfilePicture,
                            builder: (pickerService) => _buildTitle(
                              LocaleKeys.ProfilePicture.tr,
                              () async {
                                final files = await pickerService.pickMultiFile(FileType.image, allowMultiple: false);
                                if (files != null) controller.call_uploadAvatar(files);
                              },
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(state!.avatar!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildTitle(LocaleKeys.CoverPhoto.tr, () {}),
                          Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: NetworkImage('https://www.sageisland.com/wp-content/uploads/2017/06/beat-instagram-algorithm.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _buildTitle(LocaleKeys.Details.tr, () {}),
                          //
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget _buildTitle(String title, VoidCallback onPressed) => Row(
        children: [
          Text(
            title,
            style: Get.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.navigate_before_outlined),
              label: Text(LocaleKeys.Edit.tr),
            ),
          )
        ],
      );
}
