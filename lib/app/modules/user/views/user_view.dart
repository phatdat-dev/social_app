import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/user/controllers/user_controller.dart';
import 'package:social_app/generated/locales.g.dart';

import '../../../routes/app_pages.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  String? get tag => '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            children: <Widget>[
              controller.obx((state) => Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: 200.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage('https://www.sageisland.com/wp-content/uploads/2017/06/beat-instagram-algorithm.jpg'))),
                          ),
                          Positioned(
                            top: 100.0,
                            child: Container(
                              height: 190.0,
                              width: 190.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(state!.avatar!),
                                  ),
                                  border: Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 6.0)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            state.displayName!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          const SizedBox(width: 5.0),
                          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Mo ta ve ban than...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  )),
              const SizedBox(height: 10.0),
              _buildColumnActionIcon(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    controller.obx((state) => _buildInfomation()),
                    const Divider(),
                    _buildPhotos(),
                    const Divider(),
                    _buildFriends(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _showMoreOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bcx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.feedback),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Give feedback or report this profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.block),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Block',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.link),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Copy link to profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.search),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Search Profile',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildInfomation() {
    final data = [
      {
        'title': LocaleKeys.WentFrom.tr,
        'value': 'went_to',
        'icon': Icons.place_outlined,
      },
      {
        'title': LocaleKeys.LiveIn.tr,
        'value': 'live_in',
        'icon': Icons.home_outlined,
      },
      {
        'title': LocaleKeys.Relationship.tr,
        'value': 'relationship',
        'icon': Icons.favorite_outline,
      },
      {
        'title': LocaleKeys.Phone.tr,
        'value': 'phone',
        'icon': Icons.phone_outlined,
      },
      {
        'title': LocaleKeys.Birthday.tr,
        'value': 'date_of_birth',
        'icon': Icons.date_range_outlined,
      },
      {
        'title': LocaleKeys.Address.tr,
        'value': 'address',
        'icon': Icons.location_city_outlined,
      },
    ];

    final userJson = controller.state!.toJson();

    return Builder(
      builder: (context) => Column(
        children: [
          ...Helper.listGenerateSeparated(
            data.length,
            generator: (index) {
              final item = data[index];
              return Row(
                children: <Widget>[
                  Icon(item['icon'] as IconData),
                  const SizedBox(width: 5.0),
                  Text("${item['title']}:"),
                  const SizedBox(width: 5.0),
                  Text(
                    Helper.tryFormatDateTime(userJson[item['value']] ?? ''),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              );
            },
            separator: (index) => const SizedBox(width: 5.0),
          ),
          // const SizedBox(height: 10.0),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: const Text('see more about Mohsin'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildColumnActionIcon() => Builder(
      builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.collections, color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    'following',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(MdiIcons.facebookMessenger),
                  ),
                  Text(
                    LocaleKeys.Message.tr,
                    // style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showMoreOption(context);
                    },
                  ),
                  const Text(
                    'More',
                    // style: TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ));

  Widget _buildPhotos() => Builder(
        builder: (context) => Column(
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.Photo.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _buildViewMoreButton(() {}),
              ],
            ),
            ObxValue(
                (listImageUploadOfUser) => GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listImageUploadOfUser.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        final item = listImageUploadOfUser[index];
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item['media_file_name']!),
                                fit: BoxFit.cover,
                              )),
                        );
                      },
                    ),
                controller.listImageUploadOfUser),
          ],
        ),
      );

  Widget _buildFriends() => Builder(
      builder: (context) => Column(
            children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.Friend.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Text('123 friend'),
                  ],
                ),
                const Spacer(),
                _buildViewMoreButton(() => Get.toNamed(Routes.USER_FRIEND('${controller.userId}'))),
              ]),
              ObxValue(
                  (listFriendOfUser) => GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listFriendOfUser.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.75,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final item = listFriendOfUser[index] as UsersModel;
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => Get.toNamed(Routes.USER('${item.id}')),
                                child: Ink(
                                  // width: 100,
                                  height: 125,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(item.avatar!),
                                      )),
                                ),
                              ),
                              Text(
                                item.displayName ?? '',
                                maxLines: 2,
                              ),
                            ],
                          );
                        },
                      ),
                  controller.listFriendOfUser)
            ],
          ));

  Widget _buildViewMoreButton(VoidCallback onPressed) => Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.navigate_before_outlined),
          label: Text(LocaleKeys.ViewMore.tr),
        ),
      );
}
