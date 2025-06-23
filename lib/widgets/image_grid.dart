import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/image_search_result.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageSearchResult> images;
  final Function(ImageSearchResult) onImageTap;
  
  const ImageGrid({
    Key? key,
    required this.images,
    required this.onImageTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingStandard),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.marginBetweenCards,
        mainAxisSpacing: AppSpacing.marginBetweenCards,
        childAspectRatio: 1.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return GestureDetector(
          onTap: () => onImageTap(image),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: image.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}