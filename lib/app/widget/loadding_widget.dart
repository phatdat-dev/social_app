import 'package:flutter/material.dart';
import 'package:social_app/app/core/constants/global_constant.dart';

class Loadding {
  static GlobalKey<_LoaddingWidgetState> key = GlobalKey<_LoaddingWidgetState>();

  static List<bool> stacKLoadding = [];

  static void show() async {
    stacKLoadding.add(true);
    if (key.currentContext == null && stacKLoadding.length == 1) {
      showDialog(
        context: Global.navigatorKey.currentContext!,
        barrierDismissible: true,
        builder: (context) => LoaddingWidget(key: key),
      );
    }
  }

  static void dismiss() {
    stacKLoadding.removeLast();
    if (stacKLoadding.isEmpty && key.currentContext != null) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      key = GlobalKey<_LoaddingWidgetState>();
    }
  }
}

class LoaddingWidget extends StatefulWidget {
  const LoaddingWidget({super.key});

  @override
  State<LoaddingWidget> createState() => _LoaddingWidgetState();
}

class _LoaddingWidgetState extends State<LoaddingWidget> {
  // late final AssetImage imageLoadding;

  @override
  void initState() {
    // imageLoadding = AssetImage("assets/images/loading/loading-loop.gif");
    super.initState();
  }

  @override
  void dispose() {
    // imageLoadding.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: CircularProgressIndicator()
              // Image(
              //   image: imageLoadding,
              //   width: 200,
              //   height: 200,
              // ),
              ),
        ),
      ),
    );
  }
}
