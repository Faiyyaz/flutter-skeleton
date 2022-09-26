import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final ImageProvider _errorImageProvider =
      Image.asset('images/placeholder.png').image;

  ImageBuilder({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) {
        return SizedBox(
          height: height,
          width: width,
          child: const CircularProgressIndicator(),
        );
      },
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _errorImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
