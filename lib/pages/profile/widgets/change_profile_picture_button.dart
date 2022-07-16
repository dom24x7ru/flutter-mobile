import 'package:dom24x7_flutter/pages/feed/utils.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChangeProfilePictureButton extends StatefulWidget {
  const ChangeProfilePictureButton({ Key? key }) : super(key: key);

  @override
  State<ChangeProfilePictureButton> createState() => _ChangeProfilePictureButtonState();
}

class _ChangeProfilePictureButtonState extends State<ChangeProfilePictureButton> {
  final _picker = ImagePicker();
  bool _isUploadingProfilePicture = false;

  Future<void> _changePicture() async {
    if (_isUploadingProfilePicture == true) {
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      await _updateProfilePhoto(pickedFile.path);
    } else {
      context.removeAndShowSnackbar('Картинка не выбрана');
    }
  }

  Future<void> _updateProfilePhoto(String filePath) async {
    setState(() => _isUploadingProfilePicture = true);

    // final imageUrl = await client.images.upload(AttachmentFile(path: filePath));
    // if (imageUrl == null) {
    //   debugPrint('Could not upload the image. Not setting profile picture');
    //   setState(() => _isUploadingProfilePicture = false);
    //   return;
    // }
    // // Get resized images using the Stream Feed client.
    // final results = await Future.wait([
    //   client.images.getResized(imageUrl, const Resize(500, 500)),
    //   client.images.getResized(imageUrl, const Resize(50, 50))
    // ]);
    //
    // // Update the current user data state.
    // _user = _user?.copyWith(
    //   profilePhoto: imageUrl,
    //   profilePhotoResized: results[0],
    //   profilePhotoThumbnail: results[1],
    // );

    setState(() => _isUploadingProfilePicture = false);

    // Upload the new user data for the current user.
    // if (_user != null) {
    //   await client.currentUser!.update(_user!.toMap());
    // }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final user = store.user.value!.toIMPerson();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: _isUploadingProfilePicture
                ? const CircularProgressIndicator()
                : GestureDetector(
                  onTap: _changePicture,
                  child: Avatar.huge(user: user),
              ),
            ),
          ),
          GestureDetector(
            onTap: _changePicture,
            child: const Text('Изменить фото профиля', style: AppTextStyle.textStyleAction)
          ),
        ],
      ),
    );
  }
}