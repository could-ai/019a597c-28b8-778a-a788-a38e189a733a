import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/image_enhancement_service.dart';
import '../widgets/background_selector.dart';
import '../widgets/image_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  File? _processedImage;
  bool _isProcessing = false;
  String? _selectedBackground;
  final ImagePicker _picker = ImagePicker();
  final ImageEnhancementService _enhancementService = ImageEnhancementService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _processedImage = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Błąd podczas wybierania zdjęcia: $e');
    }
  }

  Future<void> _enhanceImage() async {
    if (_selectedImage == null) {
      _showErrorDialog('Najpierw wybierz zdjęcie');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final enhanced = await _enhancementService.enhanceImage(_selectedImage!);
      setState(() {
        _processedImage = enhanced;
        _isProcessing = false;
      });
      _showSuccessDialog('Zdjęcie zostało poprawione!');
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Błąd podczas poprawiania jakości: $e');
    }
  }

  Future<void> _changeBackground() async {
    if (_selectedImage == null) {
      _showErrorDialog('Najpierw wybierz zdjęcie');
      return;
    }

    if (_selectedBackground == null) {
      _showErrorDialog('Wybierz tło profesjonalne');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final withBackground = await _enhancementService.changeBackground(
        _processedImage ?? _selectedImage!,
        _selectedBackground!,
      );
      setState(() {
        _processedImage = withBackground;
        _isProcessing = false;
      });
      _showSuccessDialog('Tło zostało zmienione!');
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Błąd podczas zmiany tła: $e');
    }
  }

  Future<void> _processAll() async {
    await _enhanceImage();
    if (_selectedBackground != null) {
      await _changeBackground();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Błąd'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wybierz źródło zdjęcia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Aparat'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesjonalna Edycja Zdjęć'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Preview Section
              ImagePreview(
                originalImage: _selectedImage,
                processedImage: _processedImage,
                isProcessing: _isProcessing,
              ),
              const SizedBox(height: 24),
              
              // Select Image Button
              ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Wybierz Zdjęcie'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              
              // Background Selector
              if (_selectedImage != null) ..[
                const Text(
                  'Wybierz Profesjonalne Tło:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                BackgroundSelector(
                  selectedBackground: _selectedBackground,
                  onBackgroundSelected: (background) {
                    setState(() {
                      _selectedBackground = background;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _enhanceImage,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Popraw Jakość'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _changeBackground,
                  icon: const Icon(Icons.landscape),
                  label: const Text('Zmień Tło'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processAll,
                  icon: const Icon(Icons.done_all),
                  label: const Text('Popraw i Zmień Tło'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
