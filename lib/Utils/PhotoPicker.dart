import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionDenied implements Exception {}

class PhotoPicker {
  final ImagePicker picker;
  PhotoPicker({ImagePicker? picker}) : picker = picker ?? ImagePicker();

  Future<String?> pick(ImageSource source) async {
    // Android's system photo picker grants access only to the chosen photo.
    // It requires no READ_MEDIA_IMAGES / READ_EXTERNAL_STORAGE permission.
    final Permission? permission = source == ImageSource.camera
        ? Permission.camera
        : Platform.isIOS
        ? Permission.photos
        : null;
    if (permission != null) {
      final status = await permission.request();
      if (!status.isGranted && !status.isLimited) throw PhotoPermissionDenied();
    }
    return (await picker.pickImage(
      source: source,
      maxWidth: 2048,
      imageQuality: 85,
    ))?.path;
  }

  Future<String?> recover() async {
    if (!Platform.isAndroid) return null;
    final response = await picker.retrieveLostData();
    if (response.exception != null) throw response.exception!;
    return response.files?.firstOrNull?.path;
  }
}
