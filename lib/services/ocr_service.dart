import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/text_detection_result.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  
  Future<List<TextDetectionResult>> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    
    List<TextDetectionResult> results = [];
    
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
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
  
  void dispose() {
    _textRecognizer.close();
  }
}