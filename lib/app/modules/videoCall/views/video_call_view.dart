import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  final controller = Get.find<VideoCallController>();
  final chanelController = TextEditingController();
  final keyyValidate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoCallView'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            const FlutterLogo(),
            Form(
              key: keyyValidate,
              child: TextFormField(
                controller: chanelController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Chanel name is mandatory';
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (keyyValidate.currentState!.validate()) {
                  // ignore: use_build_context_synchronously
                  Get.toNamed(Routes.VIDEO_CALL_DETAIL(), arguments: {'chanelName': 'flutter_chat_app'});
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
              child: const Text('Join'),
            )
          ])),
        ],
      )),
    );
  }
}
