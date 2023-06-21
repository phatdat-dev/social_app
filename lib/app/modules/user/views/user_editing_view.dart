import 'package:ckc_social_app/app/core/services/picker_service.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:ckc_social_app/app/modules/user/views/user_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../core/utils/utils.dart';

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
                          _buildTitle(LocaleKeys.Details.tr, () {
                            final _formKey = GlobalKey<FormBuilderState>();
                            showDialog<String>(
                                //barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(LocaleKeys.Overview.tr),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      content: FormBuilder(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FormBuilderTextField(
                                              name: 'wentTo',
                                              initialValue: state.wentTo,
                                              // autofocus: true,
                                              // maxLines: 3,
                                              decoration: InputDecoration(
                                                focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.red)),
                                                // prefixIcon: const Icon(Icons.cloud_circle),
                                                labelText: LocaleKeys.WentFrom.tr,
                                                // hintText: 'hintText',
                                              ),
                                            ),
                                            FormBuilderTextField(
                                              name: 'liveIn',
                                              initialValue: state.liveIn,
                                              // autofocus: true,
                                              // maxLines: 3,
                                              decoration: InputDecoration(
                                                focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.red)),
                                                // prefixIcon: const Icon(Icons.cloud_circle),
                                                labelText: LocaleKeys.LiveIn.tr,
                                                // hintText: 'hintText',
                                              ),
                                            ),
                                            FormBuilderDropdown(
                                              name: 'relationship',
                                              initialValue: state.relationship,
                                              items: Relationship.values.map((e) => DropdownMenuItem(value: e.value, child: Text(e.title))).toList(),
                                            ),
                                            FormBuilderTextField(
                                              name: 'phone',
                                              initialValue: state.phone,
                                              // autofocus: true,
                                              // maxLines: 3,
                                              decoration: InputDecoration(
                                                focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.red)),
                                                // prefixIcon: const Icon(Icons.cloud_circle),
                                                labelText: LocaleKeys.Phone.tr,
                                                // hintText: 'hintText',
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        OutlinedButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(LocaleKeys.Cancel.tr)),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.saveAndValidate()) {
                                              controller.call_editInformationUser(_formKey.currentState!.value);
                                            }
                                          },
                                          // style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.secondary),
                                          child: Text(LocaleKeys.Confirm.tr),
                                        ),
                                      ],
                                    ));
                          }),
                          UserView.buildInfomation(controller),
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
