import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment_box.dart';
import 'package:flutter/material.dart';

class CommentBoxWrapper extends StatefulWidget {
  const CommentBoxWrapper({
    Key? key,
    required this.commenter,
    required this.textEditingController,
    required this.focusNode,
    required this.addComment,
    required this.showCommentBox,
  }) : super(key: key);

  final IMPerson commenter;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String?) addComment;
  final ValueNotifier<bool> showCommentBox;

  @override
  State<CommentBoxWrapper> createState() => _CommentBoxWrapperState();
}

class _CommentBoxWrapperState extends State<CommentBoxWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() => visibility = false);
      } else {
        setState(() => visibility = true);
      }
    });
    widget.showCommentBox.addListener(_showHideCommentBox);
  }

  void _showHideCommentBox() {
    if (widget.showCommentBox.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: FadeTransition(
        opacity: _animation,
        child: Builder(builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: CommentBox(
              commenter: widget.commenter,
              textEditingController: widget.textEditingController,
              focusNode: widget.focusNode,
              onSubmitted: widget.addComment,
            ),
          );
        }),
      ),
    );
  }
}