import 'package:flutter/material.dart';

class TextFieldCommentWidget extends StatefulWidget {
  TextFieldCommentWidget({
    super.key,
    required this.textEditingController,
    this.onChanged,
    this.onSendComment,
    this.onPickImage,
    this.onPickFile,
  });

  final TextEditingController textEditingController;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSendComment;
  final VoidCallback? onPickImage;
  final VoidCallback? onPickFile;

  @override
  State<TextFieldCommentWidget> createState() => _TextFieldCommentWidgetState();
}

class _TextFieldCommentWidgetState extends State<TextFieldCommentWidget> {
  late bool isComposing;
  late StateSetter setStatee;
  @override
  void initState() {
    super.initState();
    isComposing = widget.textEditingController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    InputBorder borderInput(Color color) => OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: color),
          borderRadius: BorderRadius.circular(30),
        );
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        //elevation: 10,
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: widget.textEditingController,
                      onChanged: (text) {
                        //neu' co' du lieu trong text thi` nut gui~ se~ dc hien
                        if (!isComposing) setStatee(() => isComposing = text.isNotEmpty);
                        if (text.isEmpty) setStatee(() => isComposing = false);

                        widget.onChanged?.call(text);
                      },
                      keyboardType: TextInputType.multiline, //co the dc nhieu` dong`
                      maxLines: 10, //do dai` toi' da =10
                      minLines: 1,

                      decoration: InputDecoration(
                          hintText: 'Write something...',
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
                                      widget.onSendComment?.call(widget.textEditingController.text);
                                      setStatee(() => isComposing = false);
                                    }
                                  });
                            },
                          )),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.alternate_email_outlined), onPressed: () {}),
                IconButton(icon: const Icon(Icons.attach_file), onPressed: widget.onPickFile),
                IconButton(icon: const Icon(Icons.image_outlined), onPressed: widget.onPickImage),
              ],
            )),
      ),
    );
  }
}
