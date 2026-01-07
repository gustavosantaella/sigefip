import 'dart:io';
import 'package:flutter/material.dart';

Widget loadImage(String path, {BoxFit? fit, double? width, double? height}) {
  return Image.file(
    File(path),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.broken_image);
    },
  );
}
