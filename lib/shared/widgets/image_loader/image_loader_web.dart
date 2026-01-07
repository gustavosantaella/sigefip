import 'package:flutter/material.dart';

Widget loadImage(String path, {BoxFit? fit, double? width, double? height}) {
  return Image.network(
    path,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.broken_image);
    },
  );
}
