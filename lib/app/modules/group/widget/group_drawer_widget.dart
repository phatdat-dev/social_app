import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/constants/translate_key_constant.dart';
import 'package:social_app/app/core/services/translation_service.dart';
import 'package:social_app/app/custom/widget/check_radio_listtitle_widget.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/group/controllers/group_controller.dart';

class GroupDrawerWidget extends StatelessWidget {
  const GroupDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GroupController>();
    return Drawer(
      child: Stack(
        children: [
          ...buildClipOvalColor(context),
          ListView(
            padding: EdgeInsets.zero, //remove padding SafeArea
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
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
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.currentGroup['group_name'] ?? '',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: const Icon(Icons.favorite_outline),
                title: Text(TranslateKeys.Favorite.tr()),
                trailing: const Icon(Icons.navigate_next_outlined),
              ),
              //download
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.download_outlined),
                title: Text('Download'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),

              //location
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.location_on_outlined),
                title: Text('Location'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),
              //display
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.display_settings_outlined),
                title: Text('Display'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
              //language

              ExpansionTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(TranslateKeys.Language.tr()),
                children: TranslationService.locales
                    .map((e) => CheckRadioListTileWidget<Locale>(
                          value: e,
                          title: Text(
                            e.toString().tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          groupValue: context.locale,
                          onChanged: (value) => TranslationService.changeLocale(value!),
                        ))
                    .toList(),
              ),
              //settings
              ListTile(
                style: ListTileStyle.drawer,
                leading: const Icon(Icons.settings_outlined),
                title: Text(TranslateKeys.Setting.tr()),
                trailing: const Icon(Icons.navigate_next_outlined),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                  onPressed: () => context.read<AuthenticationController>().onSignOut(),
                  icon: const Icon(Icons.logout_outlined),
                  label: Text(TranslateKeys.LogOut.tr()),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildClipOvalColor(BuildContext context) => [
        Positioned(
          bottom: -100,
          right: -75,
          child: ClipOval(
            child: Container(
              width: 250,
              height: 250,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          right: 75,
          child: ClipOval(
            child: Container(
              width: 300,
              height: 300,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -75,
          child: ClipOval(
            child: Container(
              width: 350,
              height: 350,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ),
      ];
}
