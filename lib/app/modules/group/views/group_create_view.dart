import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../models/response/privacy_model.dart';

class GroupCreateView extends GetView<GroupController> {
  const GroupCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.CreateGroup.tr),
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
                    initialValue: 'NewGrouppp',
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
                  initialValue: listPrivacy[0].privacyId,
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
                controller.call_createGroup(_formKey.currentState!.value).then((value) => Navigator.of(context).maybePop());
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
    );
  }
}
