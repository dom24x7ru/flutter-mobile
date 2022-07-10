import 'package:cached_network_image/cached_network_image.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post_actions.dart';
import 'package:flutter/material.dart';

class PictureCarousal extends StatefulWidget {
  const PictureCarousal({Key? key, required this.enrichedActivity}) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  State<PictureCarousal> createState() => _PictureCarousalState();
}

class _PictureCarousalState extends State<PictureCarousal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _pictureCarousel(context),
    );
  }

  /// Picture carousal and interaction buttons.
  List<Widget> _pictureCarousel(BuildContext context) {
    var imageUrl = widget.enrichedActivity.extraData!['image_url'] as String;
    double aspectRatio = widget.enrichedActivity.extraData!['aspect_ratio'] as double? ?? 1.0;
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
          ),
        ),
      ),
      FeedPostActions(enrichedActivity: widget.enrichedActivity)
    ];
  }
}