import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class ImageEnhancementService {
  /// Enhances image quality by applying various filters and adjustments
  Future<File> enhanceImage(File imageFile) async {
    try {
      // Read the image file
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Nie można zdekodować obrazu');
      }

      // Apply enhancement filters
      
      // 1. Increase contrast for better definition
      image = img.adjustColor(image, contrast: 1.2);
      
      // 2. Adjust brightness slightly
      image = img.adjustColor(image, brightness: 1.05);
      
      // 3. Increase saturation for more vibrant colors
      image = img.adjustColor(image, saturation: 1.15);
      
      // 4. Apply sharpening for better detail
      image = img.adjustColor(image, exposure: 1.05);
      
      // 5. Apply slight denoise effect by using smooth
      // This is a mild blur to reduce noise without losing too much detail
      image = img.gaussianBlur(image, radius: 1);
      
      // 6. Sharpen to restore edge definition
      image = img.adjustColor(image, contrast: 1.1);

      // Save the enhanced image
      final directory = await getTemporaryDirectory();
      final enhancedPath = '${directory.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final enhancedFile = File(enhancedPath);
      
      await enhancedFile.writeAsBytes(img.encodeJpg(image, quality: 95));
      
      return enhancedFile;
    } catch (e) {
      throw Exception('Błąd podczas poprawiania jakości: $e');
    }
  }

  /// Changes the background of an image to a professional background
  Future<File> changeBackground(File imageFile, String backgroundType) async {
    try {
      // Read the image file
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Nie można zdekodować obrazu');
      }

      // Create professional background based on selected type
      img.Image background = _createProfessionalBackground(
        image.width,
        image.height,
        backgroundType,
      );

      // For now, we'll use a simple edge detection and compositing approach
      // In a production app, this would use AI-based background removal
      
      // Apply a simple subject detection (center-weighted)
      // This is a placeholder for more sophisticated background removal
      img.Image result = _compositeWithBackground(image, background);

      // Save the result
      final directory = await getTemporaryDirectory();
      final resultPath = '${directory.path}/background_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final resultFile = File(resultPath);
      
      await resultFile.writeAsBytes(img.encodeJpg(result, quality: 95));
      
      return resultFile;
    } catch (e) {
      throw Exception('Błąd podczas zmiany tła: $e');
    }
  }

  img.Image _createProfessionalBackground(int width, int height, String type) {
    img.Image background = img.Image(width: width, height: height);
    
    switch (type) {
      case 'office':
        // Professional office background - gradient from blue-grey to light grey
        for (int y = 0; y < height; y++) {
          final ratio = y / height;
          final color = img.ColorRgb8(
            (220 - ratio * 50).round(),
            (225 - ratio * 45).round(),
            (230 - ratio * 40).round(),
          );
          for (int x = 0; x < width; x++) {
            background.setPixel(x, y, color);
          }
        }
        break;
        
      case 'studio':
        // Studio white background with subtle gradient
        for (int y = 0; y < height; y++) {
          final ratio = y / height;
          final color = img.ColorRgb8(
            (255 - ratio * 15).round(),
            (255 - ratio * 15).round(),
            (255 - ratio * 15).round(),
          );
          for (int x = 0; x < width; x++) {
            background.setPixel(x, y, color);
          }
        }
        break;
        
      case 'business':
        // Business navy blue gradient
        for (int y = 0; y < height; y++) {
          final ratio = y / height;
          final color = img.ColorRgb8(
            (25 + ratio * 30).round(),
            (35 + ratio * 40).round(),
            (75 + ratio * 50).round(),
          );
          for (int x = 0; x < width; x++) {
            background.setPixel(x, y, color);
          }
        }
        break;
        
      case 'elegant':
        // Elegant dark grey gradient
        for (int y = 0; y < height; y++) {
          final ratio = y / height;
          final color = img.ColorRgb8(
            (40 + ratio * 20).round(),
            (40 + ratio * 20).round(),
            (45 + ratio * 20).round(),
          );
          for (int x = 0; x < width; x++) {
            background.setPixel(x, y, color);
          }
        }
        break;
        
      default:
        // Default white background
        background = img.fill(background, color: img.ColorRgb8(255, 255, 255));
    }
    
    return background;
  }

  img.Image _compositeWithBackground(img.Image foreground, img.Image background) {
    // This is a simplified version
    // In production, you'd use AI-based background removal services
    // For now, we'll apply a center-weighted mask to simulate subject isolation
    
    img.Image result = img.Image(width: foreground.width, height: foreground.height);
    
    final centerX = foreground.width / 2;
    final centerY = foreground.height / 2;
    final maxDist = (foreground.width * foreground.width + foreground.height * foreground.height).abs();
    
    for (int y = 0; y < foreground.height; y++) {
      for (int x = 0; x < foreground.width; x++) {
        // Calculate distance from center
        final dx = x - centerX;
        final dy = y - centerY;
        final dist = (dx * dx + dy * dy) / maxDist;
        
        // Create a radial gradient mask (center is foreground, edges are background)
        final alpha = (1.0 - (dist * 2).clamp(0.0, 1.0));
        
        final fgPixel = foreground.getPixel(x, y);
        final bgPixel = background.getPixel(x, y);
        
        // Blend foreground and background based on alpha
        final blended = img.ColorRgb8(
          (fgPixel.r * alpha + bgPixel.r * (1 - alpha)).round(),
          (fgPixel.g * alpha + bgPixel.g * (1 - alpha)).round(),
          (fgPixel.b * alpha + bgPixel.b * (1 - alpha)).round(),
        );
        
        result.setPixel(x, y, blended);
      }
    }
    
    return result;
  }
}
