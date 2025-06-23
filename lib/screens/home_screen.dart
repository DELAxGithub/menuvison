import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/text_detection_result.dart';
import '../models/image_search_result.dart';
import '../services/camera_service.dart';
import '../services/ocr_service.dart';
import '../services/image_search_service.dart';
import '../config/env_config.dart';
import '../widgets/camera_view.dart';
import '../widgets/text_overlay.dart';
import '../widgets/image_grid.dart';
import 'image_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraService _cameraService = CameraService();
  final OcrService _ocrService = OcrService();
  late ImageSearchService _imageSearchService;
  
  bool _isLoading = false;
  XFile? _capturedImage;
  List<TextDetectionResult> _textDetections = [];
  List<ImageSearchResult> _searchResults = [];
  String? _selectedText;
  Size? _imageSize;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    try {
      await _cameraService.initialize();
      _imageSearchService = ImageSearchService(
        apiKey: EnvConfig.googleCustomSearchApiKey,
        searchEngineId: EnvConfig.googleSearchEngineId,
      );
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted) {
        _showError('Failed to initialize camera: $e');
      }
    }
  }
  
  Future<void> _captureAndProcess() async {
    setState(() => _isLoading = true);
    
    try {
      final photo = await _cameraService.takePicture();
      if (photo == null) return;
      
      setState(() => _capturedImage = photo);
      
      // Get actual image dimensions
      final imageFile = File(photo.path);
      final decodedImage = await decodeImageFromList(await imageFile.readAsBytes());
      _imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
      
      final detections = await _ocrService.recognizeText(photo.path);
      setState(() {
        _textDetections = detections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to process image: $e');
    }
  }
  
  Future<void> _searchForText(String text) async {
    setState(() {
      _isLoading = true;
      _selectedText = text;
    });
    
    try {
      final results = await _imageSearchService.searchImages(text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to search images: $e');
    }
  }
  
  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  void _reset() {
    setState(() {
      _capturedImage = null;
      _textDetections = [];
      _searchResults = [];
      _selectedText = null;
      _imageSize = null;
    });
  }
  
  void _viewImageDetail(ImageSearchResult image) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ImageDetailScreen(image: image),
      ),
    );
  }
  
  @override
  void dispose() {
    _cameraService.dispose();
    _ocrService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('MenuVision'),
        trailing: _capturedImage != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Reset'),
                onPressed: _reset,
              )
            : null,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (_capturedImage == null)
              CameraView(
                cameraService: _cameraService,
                onCapture: _captureAndProcess,
              )
            else if (_searchResults.isEmpty)
              _buildCapturedImageView()
            else
              _buildSearchResultsView(),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCapturedImageView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(_capturedImage!.path),
          fit: BoxFit.contain,
        ),
        if (_textDetections.isNotEmpty && _imageSize != null)
          LayoutBuilder(
            builder: (context, constraints) {
              return TextOverlay(
                detections: _textDetections,
                onTextTap: _searchForText,
                imageSize: _imageSize!,
                screenSize: Size(constraints.maxWidth, constraints.maxHeight),
              );
            },
          ),
      ],
    );
  }
  
  Widget _buildSearchResultsView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingStandard),
          color: AppColors.surface,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Results for: $_selectedText',
                  style: AppTextStyles.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Back'),
                onPressed: () {
                  setState(() {
                    _searchResults = [];
                    _selectedText = null;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ImageGrid(
            images: _searchResults,
            onImageTap: _viewImageDetail,
          ),
        ),
      ],
    );
  }
}