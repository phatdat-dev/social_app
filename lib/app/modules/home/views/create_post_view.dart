import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/services/picker_service.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();
    final txtController = TextEditingController();

    return ChangeNotifierProvider.value(
        value: PickerService(),
        builder: (context, child) {
          var filesPicker = context.select((PickerService pickerService) => pickerService.files);
          return Scaffold(
            appBar: AppBar(
              title: Text("Tạo bài viết"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedBuilder(
                    animation: txtController,
                    builder: (context, child) {
                      final bool allowPost = txtController.text.isNotEmpty || (filesPicker?.isNotEmpty ?? false);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allowPost ? null : Colors.grey.shade200,
                        ),
                        onPressed: () {},
                        child: Text('Đăng', style: TextStyle(color: allowPost ? null : Colors.grey)),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              shrinkWrap: true,
              // controller: scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  // minVerticalPadding: 10,
                  // visualDensity: VisualDensity.compact,
                  leading: CircleAvatarWidget(radius: 25),
                  title: Text("Username Here", style: TextStyle(fontWeight: FontWeight.bold)),
                  // isThreeLine: true,
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(5),
                        child: Ink(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconTheme(
                              data: IconThemeData(size: 18, color: Colors.grey),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.public)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: 'Public'),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    WidgetSpan(child: Icon(Icons.arrow_drop_down)),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(5),
                        child: Ink(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconTheme(
                              data: IconThemeData(size: 18, color: Colors.grey),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.add)),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    TextSpan(text: 'Album'),
                                    WidgetSpan(child: SizedBox(width: 5)),
                                    WidgetSpan(child: Icon(Icons.arrow_drop_down)),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Scrollbar(
                    child: TextFormField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      // scrollController: scrollController,
                      scrollPhysics: const BouncingScrollPhysics(),
                      controller: txtController,
                      decoration: InputDecoration(
                        // filled: true,
                        // fillColor: ,
                        border: InputBorder.none,
                        hintText: 'What\'s on your Mind?',
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                //show image when push complete

                Builder(
                  builder: (context) {
                    if (filesPicker == null) {
                      return const SizedBox.shrink();
                    }
                    return StatefulBuilder(
                        builder: (context, setState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                filesPicker.length,
                                (index) => Stack(
                                  children: [
                                    kIsWeb
                                        ? Image.network(filesPicker[index].path)
                                        : Image.file(
                                            filesPicker[index],
                                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                                                const Center(child: Text('This image type is not supported')),
                                          ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CloseButton(
                                          onPressed: () {
                                            filesPicker.removeAt(index);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                )
              ],
            ),
            bottomSheet: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Builder(builder: (context) {
                final List<Widget> children = [
                  InkWell(
                    onTap: () async {
                      context.read<PickerService>().pickMultiFile(FileType.image);
                    },
                    customBorder: StadiumBorder(),
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.green,
                    ),
                  ),
                  Icon(
                    Icons.loyalty_outlined,
                    color: Colors.blue,
                  ),
                  Icon(
                    Icons.tag_faces,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                  ),
                  Icon(Icons.more_outlined),
                ];
                return IconTheme(
                    data: IconThemeData(size: 30),
                    child: Row(
                      children: children.map((e) => Expanded(child: e)).toList(),
                    ));
              }),
            ),
          );
        });
  }
}
