import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post_actions.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({Key? key, required this.enrichedActivity}) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> description = [
      TextSpan(text: enrichedActivity.extraData?['description'] as String? ?? '')
    ];
    if (enrichedActivity.extraData!['image_url'] != null) {
      description.insert(0, const TextSpan(text: ' '));
      description.insert(0,
        TextSpan(
          text: Utilities.getPersonTitle(enrichedActivity.actor!.person, enrichedActivity.actor!.flat),
          style: AppTextStyle.textStyleBold
        )
      );
    }

    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
        child: Text.rich(
          TextSpan(
            children: description,
          ),
        ),
      )
    ];
    if (enrichedActivity.extraData!['image_url'] == null) {
      widgets.add(FeedPostActions(enrichedActivity: enrichedActivity));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets
    );
  }
}