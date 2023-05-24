import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:social_app/app/modules/message/controllers/message_controller.dart';
import 'package:social_app/app/routes/app_pages.dart';

class MessageSettingProfileView extends GetView<MessageController> {
  MessageSettingProfileView({super.key});

  final _numberFormat = NumberFormat.compact(locale: 'en');
  @override
  Widget build(BuildContext context) {
    // final FireBaseService fireBaseService = Get.find<FireBaseService>();

    return Scaffold(
      backgroundColor: Colors.purple,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    //
                    Text('Tùy chỉnh', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey)),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Chủ đề'),
                      trailing: Icon(Icons.color_lens, color: Colors.green),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Cảm xúc nhanh'),
                      trailing: Icon(Icons.thumb_up, color: Colors.blue),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Biệt danh'),
                      trailing: Icon(Icons.brush, color: Colors.pink),
                    ),
                    //
                    Text('Thông tin về đoạn chat', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey)),
                    ListTile(
                      onTap: () => Get.toNamed(Routes.MESSAGE_SETTING_PROFILE_MEMBERS(Get.parameters['id']!)),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Xem thành viên'),
                      trailing: const Icon(Icons.diversity_3, color: Colors.amber),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Liên kết mời'),
                      trailing: Icon(Icons.share, color: Colors.cyan),
                    ),
                    //
                    Text('Khác', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey)),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Xem file & liên kết'),
                      trailing: Icon(Icons.photo, color: Colors.greenAccent),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Tìm kiếm trong cuộc trò chuyện'),
                      trailing: Icon(MdiIcons.searchWeb, color: Colors.blueAccent),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Tùy chỉnh thông báo'),
                      trailing: Icon(Icons.notification_important, color: Colors.purpleAccent),
                    ),

                    //
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Rời khỏi đoạn chat', style: TextStyle(color: Colors.red)),
                      trailing: CircleAvatar(
                        radius: 12,
                        child: const Icon(Icons.exit_to_app, color: Colors.red, size: 16),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
              padding: MediaQuery.of(context).viewPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: PopupMenuButton(
                      child: const Icon(Icons.more_outlined),
                      itemBuilder: (context) => [
                        const PopupMenuItem(child: Text('Đổi ảnh nhóm'), value: 1),
                        const PopupMenuItem(child: Text('Đổi ảnh nền'), value: 2),
                        const PopupMenuItem(child: Text('Đổi tên'), value: 3),
                        const PopupMenuItem(child: Text('Đổi Xóa cuộc trò chuyện'), value: 4),
                        const PopupMenuItem(child: Text('Rời nhóm'), value: 5, textStyle: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Colors.purple,
          ],
        ),
      ),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
              child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 45.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Mebina NepalMebina NepalMebina NepalMebina NepalMebina NepalNepalMebinaNepalMebinaNepalMebinaNepalMebina',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    // const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              AppBarIconWidget(icon: const Icon(Icons.local_phone), onPressed: () {}),
                              const Text(
                                'Gọi thoại',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              AppBarIconWidget(icon: const Icon(Icons.videocam), onPressed: () {}),
                              const Text(
                                'Gọi video',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              AppBarIconWidget(icon: const Icon(Icons.person_add), onPressed: () {}),
                              const Text(
                                'Thêm bạn bè',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              AppBarIconWidget(icon: const Icon(Icons.notifications), onPressed: () {}),
                              const Text(
                                'Tắt thông báo',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                _numberFormat.format(421),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('CHAT', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                _numberFormat.format(10234),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('MEDIA/FILE', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                _numberFormat.format(9182),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('LINK', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 5.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage('https://i.pinimg.com/originals/81/31/20/8131208cdb98026d71d3f89b8097c522.jpg'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
