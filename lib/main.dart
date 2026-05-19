import 'package:flutter/material.dart';
import 'services/classifier_service.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final classifier = ClassifierService();
  bool modelLoaded = false;

  try {
    await classifier.load();
    modelLoaded = true;
    print('✅ Model loaded successfully');
  } catch (e) {
    print('❌ Model load error: $e');
  }

  runApp(FreshGuardApp(
    classifier: classifier,
    modelLoaded: modelLoaded,
  ));
}

class FreshGuardApp extends StatelessWidget {
  final ClassifierService classifier;
  final bool modelLoaded;

  const FreshGuardApp({
    super.key,
    required this.classifier,
    required this.modelLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
        ),
        useMaterial3: true,
      ),
      home: modelLoaded
          ? HomeScreen(classifier: classifier)
          : const ErrorScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Model failed to load',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check assets folder contains:\n• food_model.tflite\n• labels.txt',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}