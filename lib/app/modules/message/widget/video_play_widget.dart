import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayWidget extends StatefulWidget {
  const VideoPlayWidget(this.url, {super.key});
  final String url;

  @override
  State<VideoPlayWidget> createState() => _VideoPlayWidgetState();
}

class _VideoPlayWidgetState extends State<VideoPlayWidget> {
  late final VideoPlayerController videoPlayerController;
  late final ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // Printt.yellow(widget.url);

    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: videoPlayerController.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: chewieController,
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
