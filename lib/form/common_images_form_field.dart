/*
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:qtree/ui/components/entity_image.dart';
// import 'package:qtree/ui/components/loading_screen.dart';
// import 'package:qtree/ui/styles/colors.dart';
import 'package:image/image.dart' as img;
// import 'package:qtree/utils/filesystem.dart';

class CarouselImage extends StatelessWidget {
  final String imageLocation;
  final bool isEnabled;
  final Function onDeleteCallback;

  const CarouselImage({Key? key, required this.imageLocation, required this.isEnabled, required this.onDeleteCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget imageWidget = getImageWidget(imageLocation);
    return Stack(children: [
      imageLocation.startsWith("data:")
        ? EntityImage.fromMemory(memory: imageLocation)
        : imageLocation == ''
          ? const Center(child: LoadingScreen(factor: 0.5))
          : EntityImage.fromUrl(imageRelativeUrl: imageLocation),
      isEnabled // Delete Picture
        ? PositionedDirectional(
            top: 16,
            start: 16,
            child: InkWell(child: const Icon(Icons.delete, color:QColors.main_green_1), onTap: () => onDeleteCallback())
          )
        : Container()
    ]);
  }
}

// Widget getImageWidget(String imageLocation) {
//   if (imageLocation == '') return const Center(child: LoadingScreen(factor: 0.5));
//   if (imageLocation.startsWith("data:")) return EntityImage.fromMemory(memory: imageLocation)
//   if (imageLocation.startsWith("/data/")) return EntityImage.fromMemory(memory: imageLocation)
// }

img.Image resizeImage(img.Image image, double maxSize) {
  double propsFactor = (image.height * image.width) / maxSize;
    
  if (propsFactor > 1) {
    int newWidth = (image.width * sqrt(1 / propsFactor)).floor();
    image = img.copyResize(image, width: newWidth);
  }

  return image;
}

String getMimeType(String fileName) {
  String extension = fileName.split('.').last;

  switch (extension) {
    case 'png': return "image/png";
    default: return "image/jpeg";
  }
}

String? reencodeAsBase64(XFile pic, double maxSize) {
  Uint8List bytes = File(pic.path).readAsBytesSync();
  String mimeType = getMimeType(pic.path);
  img.Image? image = img.decodeImage(bytes);
  
  if (image != null) {
    img.Image? resizedImage = resizeImage(image, maxSize);
    
    if (resizedImage != image) {
      return Base64ImageEncoder.encode(image, mimeType /*, maxBytes: 2000000*/); // a bit less than 2mb 
    } else {
      return imageBytesAsBase64(bytes, mimeType: mimeType);
    } 
  }

  return null;
}

enum PickerMode {
  camera,
  gallery
}

class Base64ImageEncoder {
  static String encode(img.Image image, String mimeType, { int? maxBytes }) {
    switch (mimeType) {
      case "image/png": return _png(image, maxBytes);
      default: return _jpg(image, maxBytes);
    }
  }

  static String _wrap(List<int> data) => imageBytesAsBase64(Uint8List.fromList(data));

  static String __jpg(img.Image image, int quality) {
    return _wrap(img.encodeJpg(image, quality: quality));
  }

  static String _jpg(img.Image image, int? maxBytes) {
    int quality = 100;

    String imageBytes = __jpg(image, quality);

    if (maxBytes != null) {
      while (imageBytes.length > maxBytes) { 
        quality -= 5;
        imageBytes = __jpg(image, quality);
      }
    }
    
    return imageBytes;
  }

  static String __png(img.Image image, int level) {
    return _wrap(img.encodePng(image, level: level));
  }

  static String _png(img.Image image, int? maxBytes) {
    int level = 6;

    String imageBytes = __png(image, level);

    if (maxBytes != null) {
      while (imageBytes.length > maxBytes) { 
        imageBytes = __png(image, ++level);
      }
    }
    
    return imageBytes;
  }
}

String imageBytesAsBase64(Uint8List bytes, { String mimeType = "image/jpeg" }) {
  String base64String = "data:$mimeType;base64,${base64Encode(bytes)}";
  return base64String;
}

*/