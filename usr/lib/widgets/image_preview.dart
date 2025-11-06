import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final File? originalImage;
  final File? processedImage;
  final bool isProcessing;

  const ImagePreview({
    super.key,
    this.originalImage,
    this.processedImage,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Przetwarzanie...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    if (processedImage != null) {
      // Show before/after comparison
      return Row(
        children: [
          if (originalImage != null)
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black87,
                    child: const Text(
                      'Przed',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.file(
                      originalImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green.shade700,
                  child: const Text(
                    'Po',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Image.file(
                    processedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (originalImage != null) {
      return Image.file(
        originalImage!,
        fit: BoxFit.cover,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Wybierz zdjęcie aby rozpocząć',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
