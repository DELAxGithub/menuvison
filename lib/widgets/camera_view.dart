import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/camera_service.dart';

class CameraView extends StatelessWidget {
  final CameraService cameraService;
  final VoidCallback onCapture;
  
  const CameraView({
    Key? key,
    required this.cameraService,
    required this.onCapture,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (!cameraService.isInitialized) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    
    return Stack(
      children: [
        CameraPreview(cameraService.controller!),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: CupertinoButton(
              onPressed: onCapture,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}