import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageOpener extends StatelessWidget {
  final File? imageFile;
  final String? baseurl;
  final bool showOnly;
  final bool send;

  const ImageOpener({
    super.key,
    required this.imageFile,
    this.baseurl = "",
    required this.showOnly,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: imageFile != null
            ? PhotoView(
                imageProvider: FileImage(imageFile!),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              )
            : Text('No Image Selected'),
      ),
    );
  }
}

imageNetwork(String url, {BoxFit fit = BoxFit.cover}) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => SizedBox(),
    errorWidget: (context, url, error) => Icon(Icons.error),
    fit: fit,
  );
}

networkImage(String url) {
  return CachedNetworkImageProvider(url);
}
