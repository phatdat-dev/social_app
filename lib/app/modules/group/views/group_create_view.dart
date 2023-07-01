import 'package:ckc_social_app/app/core/services/picker_service.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/generated/locales.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../models/response/privacy_model.dart';
import '../../post/views/post_create_view.dart';

class GroupCreateView extends GetView<GroupController> {
  final bool isCreate;
  const GroupCreateView({super.key, this.isCreate = true});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: GetBuilder(
        init: PickerService(),
        builder: (pickerService) => Scaffold(
          appBar: AppBar(
            title: Text(isCreate ? LocaleKeys.CreateGroup.tr : LocaleKeys.EditGroup.tr),
            actions: [
              SizedBox(
                width: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AuthenticationController.userAccount!.displayName!,
                            style: context.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          Text('Admin', style: context.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(AuthenticationController.userAccount!.avatar!),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: FormBuilder(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Row(
                  children: [
                    Text('${LocaleKeys.DisplayName.tr}: ', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(width: 10),
                    Expanded(
                        child: FormBuilderTextField(
                      name: 'groupName',
                      initialValue: isCreate ? 'NewGrouppp' : controller.currentGroup['group_name'],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                Text('${LocaleKeys.PrivacyUpdate.tr}: ', style: Theme.of(context).textTheme.bodyLarge),
                Builder(builder: (context) {
                  final List<PrivacyModel> listPrivacy = PrivacyModel.listPrivacy;
                  return FormBuilderRadioGroup(
                    name: 'privacy',
                    initialValue: isCreate ? listPrivacy[0].privacyId : int.parse(controller.currentGroup['privacy']),
                    activeColor: Theme.of(context).colorScheme.primary,
                    options: listPrivacy
                        .map((privacyModel) => FormBuilderFieldOption(
                              value: privacyModel.privacyId,
                              child: ListTile(
                                // contentPadding: EdgeInsets.zero,
                                leading: Icon(privacyModel.privacyIcon),
                                title: Text(privacyModel.privacyGroupName ?? ''),
                                subtitle: Text(privacyModel.privacyGroupDescription ?? ''),
                              ),
                            ))
                        .toList(),
                  );
                }),
                const SizedBox(height: 10),
                Text('${LocaleKeys.GroupImage.tr}: ', style: Theme.of(context).textTheme.bodyLarge),
                OutlinedButton.icon(
                  onPressed: () => pickerService.pickMultiFile(FileType.image, allowMultiple: false),
                  icon: Text(LocaleKeys.PickImage.tr),
                  label: const Icon(Icons.image_outlined),
                ),
                Obx(() {
                  final filesPicker = pickerService.files.map((e) => (id: null, path: e)).toList();
                  if (filesPicker.isEmpty) return const SizedBox.shrink();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: PostCreateView.buildFileAttachments(
                      filesPicker,
                      onDelete: (index) => pickerService.files.removeAt(index),
                    ),
                  );
                }),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  controller.call_createOrUpdateGroup(
                    {
                      if (!isCreate) 'groupId': controller.currentGroup['id'],
                      ..._formKey.currentState!.value,
                    },
                    pickerService.files,
                  ).then((value) => Navigator.of(context).maybePop());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              icon: const Text('OK'),
              label: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }
}
