import 'package:agora_uikit/agora_uikit.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../controllers/video_call_controller.dart';

class VideoCallDetailView extends StatefulWidget {
  const VideoCallDetailView({
    Key? key,
    required this.chanelName,
  }) : super(key: key);
  final String chanelName;

  @override
  State<VideoCallDetailView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallDetailView> {
  final controller = Get.find<VideoCallController>();
  // Instantiate the client
  late final AgoraClient client;
  late final Map<String, dynamic> agoraTestingKey;

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    agoraTestingKey = Get.find<FireBaseService>().getAgoraTestingKey();
    initAgora();
  }

  void initAgora() async {
    // final aa = await AgoraRtmClient.createInstance('appId');
    // aa.createChannel('asd');
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: controller.appId,
        channelName: agoraTestingKey['channelName'], //widget.chanelName,
        tempToken: agoraTestingKey['tempToken'],
        username: AuthenticationController.userAccount!.id!.toString(),
      ),
    );
    await client.initialize();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        client.release();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(client: client),
            ],
          ),
        ),
      ),
    );
  }
}
