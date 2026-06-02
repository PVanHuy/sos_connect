import 'dart:io';

import 'package:sos_connect/utils/dialog_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  static final _picker = ImagePicker();

  static Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileExtension = path.extension(pickedFile.path).toLowerCase();

      if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(fileExtension)) {
        return File(pickedFile.path);
      } else {
        DialogUtils.showErrorDialog('invalid_file_format'.tr);
        return null;
      }
    }
    return null;
  }

  static Future<List<File>> onGetMultipleImage() async {
    try {
      final result = await _picker.pickMultiImage();
      if (result.isNotEmpty) {
        return result.map((value) => File(value.path)).toList();
      }
    } catch (e) {
      DialogUtils.showErrorDialog('You have denied the photo permission');
    }

    return [];
  }

  static Future<List<File>> pickMultipleMediaFiles({int maxFiles = 10}) async {
    try {
      final result = await _picker.pickMultipleMedia(limit: maxFiles);

      if (result.isNotEmpty) {
        List<File> validFiles = [];

        for (var file in result) {
          final fileExtension = path.extension(file.path).toLowerCase();

          final isImage = ['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(fileExtension);
          final isVideo = ['.mp4', '.mov', '.avi', '.mkv', '.flv'].contains(fileExtension);

          if (isImage || isVideo) {
            validFiles.add(File(file.path));
          } else {
            DialogUtils.showErrorDialog('invalid_file_format'.tr);
          }
        }

        return validFiles;
      }
    } catch (e) {
      DialogUtils.showErrorDialog('You have denied the media permission');
    }

    return [];
  }
}
