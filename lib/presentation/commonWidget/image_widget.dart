import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BlendMode? colorBlendMode;
  final Color? color;
  final Alignment alignment;

  const NetworkImageWidget(
    this.imageUrl, {
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.colorBlendMode,
    this.color,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            colorBlendMode: colorBlendMode,
            color: color,
            alignment: alignment,
            errorBuilder: (context, _, __) => const SizedBox(),
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            colorBlendMode: colorBlendMode,
            color: color,
            alignment: alignment,
            fadeInDuration: const Duration(milliseconds: 100),
            placeholderFadeInDuration: Duration.zero,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, dynamic error) {
              return const SizedBox();
            },
          );
  }
}
