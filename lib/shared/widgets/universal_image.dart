import 'package:flutter/material.dart';
import 'image_loader/image_loader.dart'
    if (dart.library.io) 'image_loader/image_loader_io.dart'
    if (dart.library.html) 'image_loader/image_loader_web.dart';

class UniversalImage extends StatelessWidget {
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const UniversalImage({
    super.key,
    required this.path,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return loadImage(path, fit: fit, width: width, height: height);
  }
}
