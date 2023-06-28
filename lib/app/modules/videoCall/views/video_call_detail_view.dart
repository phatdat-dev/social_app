import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: controller.appId,
        channelName: widget.chanelName,
        tempToken: controller.tokenId,
      ),
    );
    await client.initialize();
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
