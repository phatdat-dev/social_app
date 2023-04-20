import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();
    ValueNotifier<List<XFile>?> _imageFileList = ValueNotifier(null);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo bài viết"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
              ),
              onPressed: () {},
              child: Text('Đăng', style: TextStyle(color: Colors.grey)),
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
                controller: TextEditingController(text: '''
                              This code creates a view for creating a post in a social media app. It includes an AppBar with a title and an action button, a ListTile with a CircleAvatarWidget, a Text widget, two InkWells with an IconTheme and a Text.Rich widget.  
                               Step by Step Explanation:  
                              1. The code starts by importing the Material package and the CircleAvatarWidget from the social_app/app/widget directory.  
                              2. Next, it creates a CreatePostView class that extends StatelessWidget.  
                              3. The build method is then defined which returns a Scaffold widget.  
                              4. The Scaffold widget has an AppBar with a title and an action button.  
                              5. The body of the Scaffold widget is a Padding widget with a Column as its child.  
                              6. The Column widget has a ListTile as its first child.  
                              7. The ListTile has a CircleAvatarWidget as its leading widget, a Text widget as its title, and a Row widget as its subtitle.  
                              8. The Row widget has two InkWells as its children.  
                              9. The first InkWell has an IconTheme and a Text.Rich widget as its child.  
                              10. The second InkWell also has an IconTheme and a Text.Rich widget as its child.  
                              11. Finally, the code ends with a SizedBox widget.This code creates a view for creating a post in a social media app. It includes an AppBar with a title and an action button, a ListTile with a CircleAvatarWidget, a Text widget, two InkWells with an IconTheme and a Text.Rich widget.  
                               Step by Step Explanation:  
                              1. The code starts by importing the Material package and the CircleAvatarWidget from the social_app/app/widget directory.  
                              2. Next, it creates a CreatePostView class that extends StatelessWidget.  
                              3. The build method is then defined which returns a Scaffold widget.  
                              4. The Scaffold widget has an AppBar with a title and an action button.  
                              5. The body of the Scaffold widget is a Padding widget with a Column as its child.  
                              6. The Column widget has a ListTile as its first child.  
                              7. The ListTile has a CircleAvatarWidget as its leading widget, a Text widget as its title, and a Row widget as its subtitle.  
                              8. The Row widget has two InkWells as its children.  
                              9. The first InkWell has an IconTheme and a Text.Rich widget as its child.  
                              10. The second InkWell also has an IconTheme and a Text.Rich widget as its child.  
                              11. Finally, the code ends with a SizedBox widget.This code creates a view for creating a post in a social media app. It includes an AppBar with a title and an action button, a ListTile with a CircleAvatarWidget, a Text widget, two InkWells with an IconTheme and a Text.Rich widget.  
                               Step by Step Explanation:  
                              1. The code starts by importing the Material package and the CircleAvatarWidget from the social_app/app/widget directory.  
                              2. Next, it creates a CreatePostView class that extends StatelessWidget.  
                              3. The build method is then defined which returns a Scaffold widget.  
                              4. The Scaffold widget has an AppBar with a title and an action button.  
                              5. The body of the Scaffold widget is a Padding widget with a Column as its child.  
                              6. The Column widget has a ListTile as its first child.  
                              7. The ListTile has a CircleAvatarWidget as its leading widget, a Text widget as its title, and a Row widget as its subtitle.  
                              8. The Row widget has two InkWells as its children.  
                              9. The first InkWell has an IconTheme and a Text.Rich widget as its child.  
                              10. The second InkWell also has an IconTheme and a Text.Rich widget as its child.  
                              11. Finally, the code ends with a SizedBox widget.This code creates a view for creating a post in a social media app. It includes an AppBar with a title and an action button, a ListTile with a CircleAvatarWidget, a Text widget, two InkWells with an IconTheme and a Text.Rich widget.  
                               Step by Step Explanation:  
                              1. The code starts by importing the Material package and the CircleAvatarWidget from the social_app/app/widget directory.  
                              2. Next, it creates a CreatePostView class that extends StatelessWidget.  
                              3. The build method is then defined which returns a Scaffold widget.  
                              4. The Scaffold widget has an AppBar with a title and an action button.  
                              5. The body of the Scaffold widget is a Padding widget with a Column as its child.  
                              6. The Column widget has a ListTile as its first child.  
                              7. The ListTile has a CircleAvatarWidget as its leading widget, a Text widget as its title, and a Row widget as its subtitle.  
                              8. The Row widget has two InkWells as its children.  
                              9. The first InkWell has an IconTheme and a Text.Rich widget as its child.  
                              10. The second InkWell also has an IconTheme and a Text.Rich widget as its child.  
                              11. Finally, the code ends with a SizedBox widget.This code creates a view for creating a post in a social media app. It includes an AppBar with a title and an action button, a ListTile with a CircleAvatarWidget, a Text widget, two InkWells with an IconTheme and a Text.Rich widget.  
                               Step by Step Explanation:  
                              1. The code starts by importing the Material package and the CircleAvatarWidget from the social_app/app/widget directory.  
                              2. Next, it creates a CreatePostView class that extends StatelessWidget.  
                              3. The build method is then defined which returns a Scaffold widget.  
                              4. The Scaffold widget has an AppBar with a title and an action button.  
                              5. The body of the Scaffold widget is a Padding widget with a Column as its child.  
                              6. The Column widget has a ListTile as its first child.  
                              7. The ListTile has a CircleAvatarWidget as its leading widget, a Text widget as its title, and a Row widget as its subtitle.  
                              8. The Row widget has two InkWells as its children.  
                              9. The first InkWell has an IconTheme and a Text.Rich widget as its child.  
                              10. The second InkWell also has an IconTheme and a Text.Rich widget as its child.  
                              11. Finally, the code ends with a SizedBox widget.
                              zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
                               '''),
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
          ValueListenableBuilder(
            valueListenable: _imageFileList,
            builder: (context, value, child) {
              if (value == null) {
                return const SizedBox();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    value.length,
                    (index) => kIsWeb
                        ? Image.network(value[index].path)
                        : Image.file(
                            File(value[index].path),
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                                const Center(child: Text('This image type is not supported')),
                          )),
              );
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
                _imageFileList.value = await controller.pickMultiImage();
              },
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
  }
}
