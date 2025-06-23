import 'package:flutter/material.dart';

class TextDetectionResult {
  final String text;
  final Rect boundingBox;
  
  TextDetectionResult({
    required this.text,
    required this.boundingBox,
  });
}