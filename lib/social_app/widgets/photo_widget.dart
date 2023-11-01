import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A stateless widget for displaying network images with a fade-in effect and caching.
class PhotoWidget extends StatelessWidget {
  /// The URL of the image to be displayed.
  final String url;

  /// Constructs a [PhotoWidget] with the specified [url].
  const PhotoWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // Adds a padding to the top of the image to create spacing.
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      // Clips the image with rounded corners.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        // Displays a fade-in image with a placeholder while loading.
        child: FadeInImage(
          fadeInDuration: const Duration(milliseconds: 500),
          // Placeholder image set to a transparent placeholder.
          placeholder: MemoryImage(kTransparentImage),
          // Actual image loaded using CachedNetworkImageProvider for efficient caching.
          image: CachedNetworkImageProvider(url),
        ),
      ),
    );
  }
}
