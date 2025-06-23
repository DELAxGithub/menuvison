import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/text_detection_result.dart';

class TextOverlay extends StatelessWidget {
  final List<TextDetectionResult> detections;
  final Function(String) onTextTap;
  final Size imageSize;
  final Size screenSize;
  
  const TextOverlay({
    Key? key,
    required this.detections,
    required this.onTextTap,
    required this.imageSize,
    required this.screenSize,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: detections.map((detection) {
        final scaleX = screenSize.width / imageSize.width;
        final scaleY = screenSize.height / imageSize.height;
        
        final scaledRect = Rect.fromLTRB(
          detection.boundingBox.left * scaleX,
          detection.boundingBox.top * scaleY,
          detection.boundingBox.right * scaleX,
          detection.boundingBox.bottom * scaleY,
        );
        
        return Positioned(
          left: scaledRect.left,
          top: scaledRect.top,
          width: scaledRect.width,
          height: scaledRect.height,
          child: GestureDetector(
            onTap: () => onTextTap(detection.text),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textOverlay.withValues(alpha: AppColors.textOverlayOpacity),
                borderRadius: BorderRadius.circular(AppSpacing.radiusOverlay),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingXSmall,
                vertical: AppSpacing.paddingXSmall / 2,
              ),
              child: Center(
                child: Text(
                  detection.text,
                  style: AppTextStyles.ocrOverlay,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}