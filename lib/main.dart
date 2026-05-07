import 'package:flutter/material.dart';
import 'services/classifier_service.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final classifier = ClassifierService();

  try {
    await classifier.load();
  } catch (e) {
    debugPrint('Model load error: $e');
  }

  runApp(FreshGuardApp(classifier: classifier));
}

class FreshGuardApp extends StatelessWidget {
  final ClassifierService classifier;
  const FreshGuardApp({super.key, required this.classifier});

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
      home: HomeScreen(classifier: classifier),
    );
  }
}