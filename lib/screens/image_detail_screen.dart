import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/image_search_result.dart';

class ImageDetailScreen extends StatelessWidget {
  final ImageSearchResult image;
  
  const ImageDetailScreen({
    Key? key,
    required this.image,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Image Detail'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: image.imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: AppColors.error,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}