import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './comment_child_widget.dart';
import './root_comment_widget.dart';
import './tree_theme_data.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);
typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CommentTreeWidget<Root, Child> extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = 'CommentTreeWidget';

  final Root root;
  final List<Child> replies;

  final AvatarWidgetBuilder<Root>? avatarRoot;
  final ContentBuilder<Root>? contentRoot;

  final AvatarWidgetBuilder<Child>? avatarChild;
  final ContentBuilder<Child>? contentChild;
  final TreeThemeData treeThemeData;

  const CommentTreeWidget({
    required this.root,
    required this.replies,
    this.treeThemeData = const TreeThemeData(lineWidth: 1),
    this.avatarRoot,
    this.contentRoot,
    this.avatarChild,
    this.contentChild,
  });

  @override
  _CommentTreeWidgetState<Root, Child> createState() => _CommentTreeWidgetState<Root, Child>();
}

class _CommentTreeWidgetState<Root, Child> extends State<CommentTreeWidget<Root, Child>> {
  @override
  Widget build(BuildContext context) {
    final PreferredSize avatarRoot = widget.avatarRoot!(context, widget.root);
    return Provider<TreeThemeData>.value(
      value: widget.treeThemeData,
      child: Column(
        children: [
          RootCommentWidget(
            avatarRoot,
            widget.contentRoot!(context, widget.root),
          ),
          ...widget.replies.map(
            (e) => CommentChildWidget(
              isLast: widget.replies.indexOf(e) == (widget.replies.length - 1),
              avatar: widget.avatarChild!(context, e),
              avatarRoot: avatarRoot.preferredSize,
              content: widget.contentChild!(context, e),
            ),
          )
        ],
      ),
    );
  }
}
