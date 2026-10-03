// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:stylebox_dashboard/core/localization/app_localizations.dart';
import 'package:stylebox_dashboard/core/services/clothing_detection_service.dart';
import 'package:stylebox_dashboard/core/services/segmentation_service.dart';
import 'package:stylebox_dashboard/core/utils/app_colors.dart';

class AiScannerWidget extends StatefulWidget {
  final Function(File image, String detectedFood) onScanComplete;

  const AiScannerWidget({super.key, required this.onScanComplete});

  @override
  State<AiScannerWidget> createState() => _AiScannerWidgetState();
}

class _AiScannerWidgetState extends State<AiScannerWidget>
    with SingleTickerProviderStateMixin {
  File? _image;
  bool _isScanning = false;
  List<SegmentationResult> _segmentationResults = [];
  String? _detectedFood;
  Size? _imageSize;

  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  final SegmentationService _segmentationService = SegmentationService();
  final ClothingDetectionService _clothingDetectionService =
      ClothingDetectionService();
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _segmentationService.dispose();
    _clothingDetectionService.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndScan() async {
    if (_isPicking) return;
    _isPicking = true;
    XFile? pickedFile;
    try {
      pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
    } on PlatformException catch (e) {
      debugPrint('ImagePicker platform error: ${e.code} ${e.message}');
    } catch (e) {
      debugPrint('ImagePicker error: $e');
    } finally {
      _isPicking = false;
    }

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile!.path);
      _isScanning = true;
      _segmentationResults = [];
      _detectedFood = null;
    });
    _animationController.forward();

    final decodedImage = await decodeImageFromList(await _image!.readAsBytes());
    setState(() {
      _imageSize = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );
    });

    await _performScan(_image!);
  }

  Future<void> _performScan(File imageFile) async {
    final List<SegmentationResult> updatedResults = [];
    final Set<String> allDetectedUnique = {};

    try {
      // 1. Decode image for cropping
      final imageBytes = await imageFile.readAsBytes();
      final img.Image? fullImage = img.decodeImage(imageBytes);
      if (fullImage == null) throw Exception("Failed to decode image");

      // 2. Label the whole picture (clothing items only)
      final wholeImage = await _clothingDetectionService.detectClothing(
        imageFile,
      );
      allDetectedUnique.addAll(wholeImage.map((r) => r.label));

      // 3. ML Kit Object Detection (for bounding boxes), then label each crop
      try {
        final mlKitObjects = await _segmentationService.detectObjects(
          imageFile,
        );

        for (var obj in mlKitObjects) {
          final box = obj.boundingBox;
          int left = box.left.toInt().clamp(0, fullImage.width - 1);
          int top = box.top.toInt().clamp(0, fullImage.height - 1);
          int width = box.width.toInt().clamp(1, fullImage.width - left);
          int height = box.height.toInt().clamp(1, fullImage.height - top);

          img.Image crop = img.copyCrop(
            fullImage,
            x: left,
            y: top,
            width: width,
            height: height,
          );
          final result = await _clothingDetectionService
              .detectClothingFromImage(crop);

          String? finalLabel;
          if (result != null) {
            allDetectedUnique.add(result.label);
            finalLabel = result.label;
          } else if (obj.label == 'Fashion good') {
            // ML Kit knows it's apparel but not which piece
            finalLabel = 'Clothing item';
          }

          if (finalLabel != null) {
            updatedResults.add(
              SegmentationResult(boundingBox: box, label: finalLabel),
            );
          }
        }

        // 4. Fallback: one piece filling the whole photo gives no object box,
        // so draw one box over the center with the best whole-image label.
        if (updatedResults.isEmpty && wholeImage.isNotEmpty) {
          double w = fullImage.width.toDouble();
          double h = fullImage.height.toDouble();

          updatedResults.add(
            SegmentationResult(
              boundingBox: Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8),
              label: wholeImage.first.label,
            ),
          );
        }
      } catch (e) {
        debugPrint("ML Kit error: $e");
      }
    } catch (e) {
      debugPrint("Full detection error: $e");
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _segmentationResults = updatedResults;
        // Empty string = nothing recognised; the form then lets the owner
        // type the items manually.
        _detectedFood = allDetectedUnique.join(", ");
        _isScanning = false;
      });
      _animationController.stop();

      widget.onScanComplete(_image!, _detectedFood!);
    }
  }

  // Combined results helper removed (not used)

  @override
  Widget build(BuildContext context) {
    // ... inside state

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ... (rest of the UI uses displayResults)
        GestureDetector(
          onTap: _isScanning ? null : _pickImageAndScan,
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF14121F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isScanning ? AppColors.secoundryColor : Colors.white12,
                width: _isScanning ? 2 : 1,
              ),
              boxShadow: _isScanning
                  ? [
                      BoxShadow(
                        color: AppColors.secoundryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_image == null)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checkroom_rounded,
                            size: 60,
                            color: AppColors.secoundryColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tap to Scan Clothes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'On-device AI clothing recognition',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Image.file(_image!, fit: BoxFit.contain),

                    if (_isScanning)
                      AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: _scanAnimation.value * 280,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.secoundryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secoundryColor,
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    if (!_isScanning &&
                        _segmentationResults.isNotEmpty &&
                        _imageSize != null)
                      CustomPaint(
                        painter: BoundingBoxPainter(
                          _segmentationResults,
                          _imageSize!,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (!_isScanning && _detectedFood != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secoundryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.secoundryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _detectedFood!.isEmpty
                        ? AppLocalizations.of(context)!.noClothesDetected
                        : 'Detected: $_detectedFood',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle_outline, color: Colors.white),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<SegmentationResult> results;
  final Size imageSize;

  BoundingBoxPainter(this.results, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (results.isEmpty) return;

    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    // Maintain aspect ratio fit based on BoxFit.contain behavior
    double scale = scaleX < scaleY ? scaleX : scaleY;

    double dx = (size.width - imageSize.width * scale) / 2;
    double dy = (size.height - imageSize.height * scale) / 2;

    final Paint boxPaint = Paint()
      ..color = AppColors.secoundryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint fillPaint = Paint()
      ..color = AppColors.secoundryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var result in results) {
      final rect = result.boundingBox;

      final scaledRect = Rect.fromLTRB(
        rect.left * scale + dx,
        rect.top * scale + dy,
        rect.right * scale + dx,
        rect.bottom * scale + dy,
      );

      canvas.drawRect(scaledRect, fillPaint);
      canvas.drawRect(scaledRect, boxPaint);

      // Draw label background
      final RRect labelBadge = RRect.fromRectAndRadius(
        Rect.fromLTWH(scaledRect.left, scaledRect.top - 24, 120, 24),
        const Radius.circular(4),
      );
      canvas.drawRRect(labelBadge, Paint()..color = AppColors.secoundryColor);

      // Draw text
      textPainter.text = TextSpan(
        text: ' ${result.label}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(scaledRect.left + 4, scaledRect.top - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
