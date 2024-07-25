import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';

class ImageCollection extends StatelessWidget {
  final List<String> urls;
  final double size;
  const ImageCollection({
    required this.urls,
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String compressedImage(String url) {
      return url.replaceAll(
          'w600-h600', 'w${(size).toInt()}-h${(size).toInt()}');
    }

    return SizedBox(
      width: size,
      height: size,
      child: Builder(
        builder: (context) {
          if (urls.length >= 4) {
            return Column(
              children: [
                Row(
                  children: [
                    AppImage(
                      compressedImage(urls[0]),
                      width: size / 2,
                      height: size / 2,
                      fit: BoxFit.cover,
                    ),
                    AppImage(
                      compressedImage(urls[1]),
                      width: size / 2,
                      height: size / 2,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppImage(
                      compressedImage(urls[2]),
                      width: size / 2,
                      height: size / 2,
                      fit: BoxFit.cover,
                    ),
                    AppImage(
                      compressedImage(urls[3]),
                      width: size / 2,
                      height: size / 2,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            );
          } else if (urls.isNotEmpty) {
            return AppImage(
              urls[0],
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          }
          return SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.no_photography_rounded,
              color: Theme.of(context).iconTheme.color?.withOpacity(.7),
            ),
          );
        },
      ),
    );
  }
}
