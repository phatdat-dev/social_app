import 'package:flutter/material.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 10,
              // visualDensity: VisualDensity.compact,
              leading: CircleAvatarWidget(radius: 25),
              title: Text("Username Here", style: TextStyle(fontWeight: FontWeight.bold)),
              isThreeLine: true,
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(10),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.group),
                        border: InputBorder.none,
                        hintText: 'Public',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text('Public'),
                          value: 'Public',
                        ),
                        DropdownMenuItem(
                          child: Text('Friends'),
                          value: 'Friends',
                        ),
                        DropdownMenuItem(
                          child: Text('Only Me'),
                          value: 'Only Me',
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Row(
                        children: [
                          Text('Album'),
                          Expanded(
                            child: Icon(
                              Icons.arrow_drop_down,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'What\'s on your Mind?',
                hintStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
