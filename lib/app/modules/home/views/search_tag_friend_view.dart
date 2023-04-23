import 'package:flutter/material.dart';
import 'package:social_app/app/widget/search_widget.dart';

class SearchTagFriendView extends StatelessWidget {
  const SearchTagFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Gắn thẻ bạn bè'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Xong'),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SearchWidget(
              controller: TextEditingController(),
              hintText: 'Tìm kiếm',
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Đã chọn
            Text('Đã chọn', style: Theme.of(context).textTheme.titleLarge),
            //ListView Horizontal
            Container(
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => Column(
                        children: [
                          Stack(
                            children: [
                              const CircleAvatar(radius: 30),
                              const Positioned(
                                top: 0,
                                right: 0,
                                child: Material(
                                  elevation: 1,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close, size: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Nguyễn Văn A',
                            maxLines: 2,
                          ),
                        ],
                      )),
            ),

            Text('Tất cả bạn bè', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
                child: ListView.separated(
                    itemCount: 5,
                    // shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      bool isCheck = false;
                      return StatefulBuilder(
                          builder: (context, setState) => CheckboxListTile(
                                value: isCheck,
                                onChanged: (value) {
                                  isCheck = value!;
                                  setState(() {});
                                },
                                secondary: const CircleAvatar(radius: 25),
                                title: Text('Nguyễn Văn A', style: Theme.of(context).textTheme.bodyLarge),
                                activeColor: Theme.of(context).primaryColor,
                                contentPadding: EdgeInsets.zero,
                              ));
                    }))
          ],
        ),
      ),
    );
  }
}
