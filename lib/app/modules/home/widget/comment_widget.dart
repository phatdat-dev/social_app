import 'package:ckc_social_app/app/core/services/picker_service.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/post/views/post_create_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../package/comment_tree/comment_tree.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.data, this.onSendComment, this.onReplyComment, this.onLoadMoreComment});
  final List<Map<String, dynamic>> data;
  final ValueChanged<({String text, List<String> files})>? onSendComment;
  final void Function(({String text, List<String> files}), Map<String, dynamic>)? onReplyComment;
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

  Widget _buildTextFieldComment(
      {required TextEditingController controller, required ValueChanged<({String text, List<String> files})>? onSendComment}) {
    InputBorder borderInput(Color color) => OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: color),
          borderRadius: BorderRadius.circular(30),
        );
    late bool isComposing = controller.text.isNotEmpty;
    //
    return GetBuilder(
      init: PickerService(),
      builder: (pickerService) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setStatee) => TextField(
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
                                    onSendComment?.call((text: controller.text, files: pickerService.files));
                                    controller.clear();
                                    pickerService.files.clear();
                                    setStatee(() => isComposing = false);
                                    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                  }
                                });
                          },
                        )),
                  ),
                ),
              ),
              IconButton(
                color: Get.theme.colorScheme.primary,
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () => pickerService.pickMultiFile(FileType.media, allowMultiple: false),
              ),
            ],
          ),
          Obx(
            () {
              final filesPicker = pickerService.files.map((e) => (id: null, path: e)).toList();
              return Wrap(
                children: PostCreateView.buildFileAttachments(
                  filesPicker,
                  onDelete: (index) => pickerService.files.removeAt(index),
                ).map((e) => SizedBox(width: 100, height: 100, child: e)).toList(),
              );
            },
          ),
        ],
      ),
    );
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
                      const SizedBox(height: 10),
                      if (data['fileName'] != null) SizedBox(height: 150, child: HelperWidget.buildImage('${data['fileName']}'))
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
