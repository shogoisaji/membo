import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  Future<Size?> getImageSize(XFile file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image != null) {
      return Size(image.width.toDouble(), image.height.toDouble());
    } else {
      print('Failed to decode image');
    }
    return null;
  }
}
