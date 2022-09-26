import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageBuilder extends StatelessWidget {
  final String imageUrl;
  final double size;
  final ImageProvider _errorImageProvider =
      Image.asset('images/userplaceholder.png').image;

  CircleImageBuilder({
    Key? key,
    required this.imageUrl,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: const CircularProgressIndicator(),
        );
      },
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
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
