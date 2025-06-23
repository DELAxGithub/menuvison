import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CropOverlay extends StatefulWidget {
  final Size imageSize;
  final Function(Rect) onCropAreaChanged;
  final Rect? initialCropArea;
  
  const CropOverlay({
    Key? key,
    required this.imageSize,
    required this.onCropAreaChanged,
    this.initialCropArea,
  }) : super(key: key);
  
  @override
  State<CropOverlay> createState() => _CropOverlayState();
}

class _CropOverlayState extends State<CropOverlay> {
  Rect _cropArea = const Rect.fromLTWH(0.1, 0.1, 0.8, 0.8);
  
  @override
  void initState() {
    super.initState();
    if (widget.initialCropArea != null) {
      _cropArea = widget.initialCropArea!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CropPainter(_cropArea),
      child: GestureDetector(
        onPanStart: (details) => _onPanStart(details),
        onPanUpdate: (details) => _onPanUpdate(details),
        onPanEnd: (details) => _onPanEnd(),
        child: Container(
          width: widget.imageSize.width,
          height: widget.imageSize.height,
          color: Colors.transparent,
        ),
      ),
    );
  }
  
  void _onPanStart(DragStartDetails details) {
    final localPosition = details.localPosition;
    final normalizedPosition = Offset(
      localPosition.dx / widget.imageSize.width,
      localPosition.dy / widget.imageSize.height,
    );
    
    if (_isInCropArea(normalizedPosition)) {
      // Start dragging from current position
    } else {
      // Start new crop area
      _cropArea = Rect.fromLTWH(
        normalizedPosition.dx - 0.05,
        normalizedPosition.dy - 0.05,
        0.1,
        0.1,
      );
      _constrainCropArea();
    }
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    final localPosition = details.localPosition;
    final normalizedPosition = Offset(
      localPosition.dx / widget.imageSize.width,
      localPosition.dy / widget.imageSize.height,
    );
    
    setState(() {
      _cropArea = Rect.fromLTRB(
        _cropArea.left,
        _cropArea.top,
        normalizedPosition.dx,
        normalizedPosition.dy,
      );
      _constrainCropArea();
    });
  }
  
  void _onPanEnd() {
    widget.onCropAreaChanged(_cropArea);
  }
  
  bool _isInCropArea(Offset normalizedPosition) {
    return _cropArea.contains(normalizedPosition);
  }
  
  void _constrainCropArea() {
    double left = _cropArea.left.clamp(0.0, 1.0);
    double top = _cropArea.top.clamp(0.0, 1.0);
    double right = _cropArea.right.clamp(0.0, 1.0);
    double bottom = _cropArea.bottom.clamp(0.0, 1.0);
    
    if (right <= left) right = (left + 0.1).clamp(0.0, 1.0);
    if (bottom <= top) bottom = (top + 0.1).clamp(0.0, 1.0);
    
    _cropArea = Rect.fromLTRB(left, top, right, bottom);
  }
}

class CropPainter extends CustomPainter {
  final Rect cropArea;
  
  CropPainter(this.cropArea);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    
    final cropRect = Rect.fromLTWH(
      cropArea.left * size.width,
      cropArea.top * size.height,
      cropArea.width * size.width,
      cropArea.height * size.height,
    );
    
    // Draw dark overlay outside crop area
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRect(cropRect),
      ),
      paint,
    );
    
    // Draw crop area border
    final borderPaint = Paint()
      ..color = CupertinoColors.systemBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawRect(cropRect, borderPaint);
    
    // Draw corner handles
    final handlePaint = Paint()
      ..color = CupertinoColors.systemBlue
      ..style = PaintingStyle.fill;
    
    const handleSize = 8.0;
    
    // Top-left handle
    canvas.drawRect(
      Rect.fromCenter(
        center: cropRect.topLeft,
        width: handleSize,
        height: handleSize,
      ),
      handlePaint,
    );
    
    // Top-right handle
    canvas.drawRect(
      Rect.fromCenter(
        center: cropRect.topRight,
        width: handleSize,
        height: handleSize,
      ),
      handlePaint,
    );
    
    // Bottom-left handle
    canvas.drawRect(
      Rect.fromCenter(
        center: cropRect.bottomLeft,
        width: handleSize,
        height: handleSize,
      ),
      handlePaint,
    );
    
    // Bottom-right handle
    canvas.drawRect(
      Rect.fromCenter(
        center: cropRect.bottomRight,
        width: handleSize,
        height: handleSize,
      ),
      handlePaint,
    );
  }
  
  @override
  bool shouldRepaint(CropPainter oldDelegate) {
    return oldDelegate.cropArea != cropArea;
  }
}