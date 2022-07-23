import 'dart:convert';

import 'package:dom24x7_flutter/api/socket_client.dart';
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
  late SocketClient _client;
  final _picker = ImagePicker();
  bool _isUploadingProfilePicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _changePicture() async {
    if (_isUploadingProfilePicture == true) {
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _updateProfilePhoto(pickedFile);
    } else {
      context.removeAndShowSnackbar('Картинка не выбрана');
    }
  }

  Future<void> _updateProfilePhoto(XFile pickedFile) async {
    setState(() => _isUploadingProfilePicture = true);

    final bytes = await pickedFile.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final data = {
      'base64': base64Encode(bytes),
      'name': pickedFile.name,
      'size': bytes.length,
      'width': image.width,
      'height': image.height
    };

    _client.socket.emit('file.upload', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        setState(() => _isUploadingProfilePicture = false);
        return;
      }
      if (data == null || data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Произошла неизвестная ошибка. Попробуйте позже...'), backgroundColor: Colors.red)
        );
        setState(() => _isUploadingProfilePicture = false);
        return;
      }

      // TODO: теперь можем обновить аватар пользователя
      // data['file']['link']
      setState(() => _isUploadingProfilePicture = false);
    });

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