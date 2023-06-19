import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';

import '../../../../package/comment_tree/comment_tree.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.data, this.onSendComment, this.onReplyComment, this.onLoadMoreComment});
  final List<Map<String, dynamic>> data;
  final ValueChanged<String>? onSendComment;
  final void Function(String, Map<String, dynamic>)? onReplyComment;
  final ValueChanged<Map<String, dynamic>>? onLoadMoreComment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: _buildTextFieldComment(controller: TextEditingController(), onSendComment: onSendComment),
        ),
        ...List.generate(
          data.length,
          (index) {
            final item = data.elementAt(index);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildWidgetTree(item),
            );
          },
        ),
      ],
    );
  }

  Builder _buildTextFieldComment({required TextEditingController controller, required ValueChanged<String>? onSendComment}) {
    return Builder(builder: (context) {
      InputBorder borderInput(Color color) => OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: color),
            borderRadius: BorderRadius.circular(30),
          );
      late bool isComposing = controller.text.isNotEmpty;
      //
      return StatefulBuilder(
        builder: (context, setStatee) {
          return TextField(
            controller: controller,
            onChanged: (text) {
              //neu' co' du lieu trong text thi` nut gui~ se~ dc hien
              if (!isComposing) setStatee(() => isComposing = text.isNotEmpty);
              if (text.isEmpty) setStatee(() => isComposing = false);

              // widget.onChanged?.call(text);
            },
            keyboardType: TextInputType.multiline, //co the dc nhieu` dong`
            maxLines: 10, //do dai` toi' da =10
            minLines: 1,

            decoration: InputDecoration(
                hintText: LocaleKeys.WriteAComment.tr,
                // hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                enabledBorder: borderInput(Theme.of(context).colorScheme.secondary),
                focusedBorder: borderInput(Colors.green),
                filled: true,
                fillColor: Colors.grey.shade200,
                //neu' textfield ko rong~ thi` dc phep nhan' nut, ngc lai thi` nhan' ko dc
                suffixIcon: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    setStatee = setState;
                    return IconButton(
                        icon: Icon(
                          Icons.send,
                          color: isComposing ? Theme.of(context).colorScheme.primary : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          if (isComposing) {
                            onSendComment?.call(controller.text);
                            controller.clear();
                            setStatee(() => isComposing = false);
                            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                          }
                        });
                  },
                )),
          );
        },
      );
    });
  }

  Widget buildContentComment(Map<String, dynamic> data) {
    final isShowTextFieldComment = ValueNotifier(false);

    return Builder(
        builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['displayName']}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data['comment_content']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // DefaultTextStyle(
                //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
                //   child: ,
                // )
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: Text(LocaleKeys.Like.tr),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // padding: EdgeInsets.zero,
                      ),
                      onPressed: () => isShowTextFieldComment.value = !isShowTextFieldComment.value,
                      child: Text(LocaleKeys.Reply.tr),
                    ),
                    Text(DateTime.tryParse(data['created_at'] ?? '')?.timeAgoSinceDate() ?? '', style: Theme.of(context).textTheme.bodySmall!),
                  ],
                ),
                if (data['countComment'] != null && data['countComment'] > 0 && ((data['replies'] as List?)?.isEmpty ?? true))
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // padding: EdgeInsets.zero,
                    ),
                    onPressed: () => onLoadMoreComment?.call(data),
                    child: Text("${LocaleKeys.ViewMore.tr} ${data["countComment"]} ${LocaleKeys.Reply.tr}"),
                  ),

                ValueListenableBuilder(
                    valueListenable: isShowTextFieldComment,
                    builder: (context, value, child) {
                      return AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        firstChild: const SizedBox.shrink(),
                        secondChild: _buildTextFieldComment(
                          controller: TextEditingController(text: "@${data['displayName']} "),
                          onSendComment: (value) => onReplyComment?.call(value, data),
                        ),
                        crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      );
                    }),
              ],
            ));
  }

  Widget buildWidgetTree(Map<String, dynamic> item) {
    return CommentTreeWidget<Map<String, dynamic>, Map<String, dynamic>>(
      root: item,
      replies: item['replies'] ?? [],
      treeThemeData: TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 1),
      avatarRoot: (context, data) => PreferredSize(
        child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(data['avatarUser'])),
        preferredSize: const Size.fromRadius(20),
      ),
      avatarChild: (context, data) => PreferredSize(
        child: CircleAvatar(radius: 0, backgroundImage: NetworkImage(data['avatarUser'])),
        preferredSize: const Size.fromRadius(0), //14
      ),
      contentRoot: (context, data) {
        return buildContentComment(data);
      },
      contentChild: (context, data) {
        return buildWidgetTree(data);
      },
    );
  }
}
