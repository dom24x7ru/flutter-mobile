import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({Key? key, required this.enrichedActivity}) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: Utilities.getPersonTitle(enrichedActivity.actor!.person, enrichedActivity.actor!.flat),
              style: AppTextStyle.textStyleBold),
            const TextSpan(text: ' '),
            TextSpan(text: enrichedActivity.extraData?['description'] as String? ?? ''),
          ],
        ),
      ),
    );
  }
}