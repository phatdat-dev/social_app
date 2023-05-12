import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/utils/utils.dart';

class LoadMovieWidget extends StatefulWidget {
  const LoadMovieWidget(this.url, {super.key});

  final String url;

  @override
  State<LoadMovieWidget> createState() => _LoadMovieWidgetState();
}

class _LoadMovieWidgetState extends State<LoadMovieWidget> {
  double progresss = 0;
  InAppWebViewController? webViewController;

  /// Toggles the player's full screen mode.
  void toggleFullScreenMode(bool isFullScreen) {
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {},
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            // var uri = navigationAction.request.url!;

            // if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
            //   if (await canLaunchUrl(uri)) {
            //     // Launch the App
            //     await launchUrl(
            //       uri,
            //     );
            //     // and cancel the request
            //     return NavigationActionPolicy.CANCEL;
            //   }
            // }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {},
          onLoadError: (controller, url, code, message) {},
          onProgressChanged: (controller, progress) {
            setState(() {
              progresss = progress / 100;
            });
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {},
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
          onEnterFullscreen: (controller) {
            Printt.white('fullScreennn');

            //start rotate screen
            //https://stackoverflow.com/questions/50322054/flutter-how-to-set-and-lock-screen-orientation-on-demand
            toggleFullScreenMode(true);
          },
          onExitFullscreen: (controller) {
            Printt.white('exit fullScreennn');

            //end rotate screen
            toggleFullScreenMode(false);
          },
        ),
        progresss < 1.0 ? LinearProgressIndicator(value: progresss) : const SizedBox(),
      ],
    );
  }
}
