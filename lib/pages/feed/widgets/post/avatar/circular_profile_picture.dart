import 'package:cached_network_image/cached_network_image.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class CircularProfilePicture extends StatelessWidget {
  const CircularProfilePicture({
    Key? key,
    required this.size,
    required this.user,
    required this.fontSize,
    this.isThumbnail = false,
  }) : super(key: key);

  final IMPerson user;

  final double size;
  final double fontSize;

  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    final profilePhoto = isThumbnail
        ? user.profilePhotoThumbnail
        : user.profilePhotoResized;

    return (profilePhoto == null)
        ? Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                Utilities.getAvatarStr(user.person),
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          )
        : SizedBox(
            width: size,
            height: size,
            child: CachedNetworkImage(
              imageUrl: profilePhoto,
              fit: BoxFit.contain,
              imageBuilder: (context, imageProvider) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          );
  }
}