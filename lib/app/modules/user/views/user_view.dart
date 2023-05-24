import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/user/controllers/user_controller.dart';

import '../../../routes/app_pages.dart';

class UserView extends GetView<UserController> {
  final int userId;
  const UserView(this.userId, {super.key});

  @override
  String? get tag => '$userId';

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
                                  border: Border.all(color: Colors.white, width: 6.0)),
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
                    ..._buildInfomation(),
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
                  Icon(
                    Icons.feedback,
                    color: Colors.black,
                  ),
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
                  Icon(
                    Icons.block,
                    color: Colors.black,
                  ),
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
                  Icon(
                    Icons.link,
                    color: Colors.black,
                  ),
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
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
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

  List<Widget> _buildInfomation() => [
        const Row(
          children: <Widget>[
            Icon(Icons.work),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Founder and CEO at',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'SignBox',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Row(
          children: <Widget>[
            Icon(Icons.work),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Works at',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'SignBox',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Row(
          children: <Widget>[
            Icon(Icons.school),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Studied Computer Science at',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
        const Wrap(
          children: <Widget>[
            Text(
              'Abc University',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Row(
          children: <Widget>[
            Icon(Icons.home),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Lives in',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Pakistan',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Row(
          children: <Widget>[
            Icon(Icons.location_on),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'From',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Lahore',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Row(
          children: <Widget>[
            Icon(Icons.list),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Followed by',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              '100K people',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('see more about Mohsin'),
          ),
        ),
      ];
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
                    icon: const Icon(Icons.message, color: Colors.black),
                  ),
                  const Text(
                    'Message',
                    // style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
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
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Photos',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                )),
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Friends',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text('123 friend'),
                    ],
                  ),
                  const Spacer(),
                  Text('Search Friends >', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.blue)),
                ],
              ),
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
}
