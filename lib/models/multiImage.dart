import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker_web/image_picker_web.dart';

class MultiImage {
  bool isUploaded = false;
  final String url;
  File file;
  Uint8List uint8list;
  MediaInfo mediaInfo;

  MultiImage(
      {this.isUploaded, this.url, this.file, this.uint8list, this.mediaInfo});
}
