import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        throw Exception('No cameras available');
      }
      
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _controller!.initialize();
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      rethrow;
    }
  }
  
  Future<XFile?> takePicture() async {
    if (!isInitialized) {
      throw Exception('Camera not initialized');
    }
    
    try {
      final XFile photo = await _controller!.takePicture();
      return photo;
    } catch (e) {
      debugPrint('Take picture error: $e');
      return null;
    }
  }
  
  void dispose() {
    _controller?.dispose();
  }
}