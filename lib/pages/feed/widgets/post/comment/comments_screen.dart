import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_comment_box.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_state.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comments_list.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen that shows all comments for a given post.
class CommentsScreen extends StatefulWidget {
  /// Creates a new [CommentsScreen].
  const CommentsScreen({
    Key? key,
    required this.enrichedActivity,
    required this.activityOwnerData,
  }) : super(key: key);

  final EnrichedActivity enrichedActivity;

  /// Owner / [User] of the activity.
  final IMPerson activityOwnerData;

  /// MaterialPageRoute to this screen.
  static Route route({
    required EnrichedActivity enrichedActivity,
    required IMPerson activityOwnerData,
  }) =>
      MaterialPageRoute(
        builder: (context) => CommentsScreen(
          enrichedActivity: enrichedActivity,
          activityOwnerData: activityOwnerData,
        ),
      );

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late SocketClient _client;
  final List<dynamic> _listeners = [];
  EnrichedActivity? _enrichedActivity;

  late FocusNode commentFocusNode;
  late CommentState commentState;

  @override
  void initState() {
    super.initState();
    commentFocusNode = FocusNode();
    commentState = CommentState(
      activityId: widget.enrichedActivity.id.toString(),
      activityOwnerData: widget.activityOwnerData,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      setState(() => _enrichedActivity = widget.enrichedActivity);
      var listener = _client.on('posts', this, (event, cont) {
        final posts = store.posts.list;
        if (posts != null) {
          final list = posts.where((post) => post.id == _enrichedActivity!.id).toList();
          if (list.isNotEmpty) {
            setState(() => _enrichedActivity = list[0].enrichedActivity!);
          }
        }
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: commentState),
        ChangeNotifierProvider.value(value: commentFocusNode),
      ],
      child: GestureDetector(
        onTap: () {
          commentState.resetCommentFocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: Header.get(context, Utilities.getHeaderTitle('Комментарии')),
          body: Stack(
            children: [
              CommentsList(enrichedActivity: _enrichedActivity ?? widget.enrichedActivity),
              CommentCommentBox(enrichedActivity: _enrichedActivity ?? widget.enrichedActivity),
            ],
          ),
        ),
      ),
    );
  }
}