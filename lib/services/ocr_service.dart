import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/text_detection_result.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  
  Future<List<TextDetectionResult>> recognizeText(String imagePath, {Rect? cropArea}) async {
    final inputImage = InputImage.fromFile(File(imagePath));
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    
    List<TextDetectionResult> results = [];
    
    // Get image dimensions for crop area calculations
    Size? imageSize;
    if (cropArea != null) {
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      imageSize = Size(frame.image.width.toDouble(), frame.image.height.toDouble());
      frame.image.dispose();
      codec.dispose();
    }
    
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        // If crop area is specified, filter text within the area
        if (cropArea != null && imageSize != null) {
          final boundingBox = line.boundingBox;
          final normalizedBoundingBox = Rect.fromLTWH(
            boundingBox.left / imageSize.width,
            boundingBox.top / imageSize.height,
            boundingBox.width / imageSize.width,
            boundingBox.height / imageSize.height,
          );
          
          // Check if the text is within the crop area
          if (!cropArea.overlaps(normalizedBoundingBox)) {
            continue;
          }
        }
        
        results.add(
          TextDetectionResult(
            text: line.text,
            boundingBox: line.boundingBox,
          ),
        );
      }
    }
    
    return results;
  }
  
  Future<List<TextDetectionResult>> recognizeTextInMenus(String imagePath, {Rect? cropArea}) async {
    final results = await recognizeText(imagePath, cropArea: cropArea);
    
    // Filter for menu-like text patterns
    final menuResults = <TextDetectionResult>[];
    
    for (final result in results) {
      final text = result.text.toLowerCase();
      
      // Look for menu indicators
      if (_isMenuLikeText(text)) {
        menuResults.add(result);
      }
    }
    
    return menuResults.isNotEmpty ? menuResults : results;
  }
  
  bool _isMenuLikeText(String text) {
    // Menu keywords and patterns
    final menuKeywords = [
      'menu', 'price', 'dish', 'course', 'special', 'today',
      'lunch', 'dinner', 'breakfast', 'appetizer', 'main',
      'dessert', 'drink', 'beverage', 'wine', 'beer',
      'yen', '円', '\$', '€', '£', 'usd', 'jpy'
    ];
    
    // Check for price patterns
    final pricePattern = RegExp(r'[\$¥€£]\s*\d+|^\d+\s*円|\d+\.\d{2}');
    if (pricePattern.hasMatch(text)) {
      return true;
    }
    
    // Check for menu keywords
    for (final keyword in menuKeywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    
    // Check for typical menu item structure (text with numbers/prices)
    if (text.contains(RegExp(r'\d')) && text.length > 3) {
      return true;
    }
    
    return false;
  }
  
  void dispose() {
    _textRecognizer.close();
  }
}