import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import '../data/models/prediction_result.dart';

class ClassifierService {
  late Interpreter _interpreter;
  late List<String> _labels;
  static const int inputSize = 224;
  bool _isLoaded = false;

  Future<void> load() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/food_model.tflite');
      final rawLabels = await rootBundle.loadString('assets/labels.txt');
      _labels = rawLabels
          .trim()
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  bool get isLoaded => _isLoaded;

  PredictionResult predict(img.Image image) {
    final resized = img.copyResize(image, width: inputSize, height: inputSize);
    final input = _imageToFloat32List(resized);
    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter.run(
      input.reshape([1, inputSize, inputSize, 3]),
      output,
    );

    final scores = List<double>.from(output[0]);
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final maxIndex = scores.indexOf(maxScore);
    final label = _labels[maxIndex];

    return PredictionResult(
      label: label,
      fruitName: PredictionResult.extractFruitName(label),
      isFresh: label.startsWith('fresh'),
      confidence: maxScore,
    );
  }

  Float32List _imageToFloat32List(img.Image image) {
    final bytes = Float32List(inputSize * inputSize * 3);
    int idx = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        bytes[idx++] = pixel.r / 255.0;
        bytes[idx++] = pixel.g / 255.0;
        bytes[idx++] = pixel.b / 255.0;
      }
    }
    return bytes;
  }

  void dispose() {
    if (_isLoaded) _interpreter.close();
  }
}