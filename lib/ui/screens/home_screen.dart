import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import '../../services/classifier_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  final ClassifierService classifier;
  const HomeScreen({super.key, required this.classifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  Future<void> _classify() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    try {
      final bytes = await _selectedImage!.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception("Could not decode image");

      final result = widget.classifier.predict(image);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageFile: _selectedImage!,
            result: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        title: const Text(
          '🍎 FreshGuard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Check your fruit\'s freshness instantly',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Image Preview Box
            GestureDetector(
              onTap: _showSourceDialog,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 64,
                      color: Color(0xFF4CAF50),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tap to upload or capture a fruit',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gallery & Camera Buttons
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Analyze Button
            ElevatedButton(
              onPressed: _selectedImage != null && !_isLoading
                  ? _classify
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Analyze Fruit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF4CAF50)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: Color(0xFF4CAF50)),
              title: const Text('Take a Photo'),
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
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFF4CAF50)),
      label: Text(label, style: const TextStyle(color: Color(0xFF4CAF50))),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFF4CAF50)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}