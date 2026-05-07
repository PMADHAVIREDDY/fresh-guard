class PredictionResult {
  final String label;
  final String fruitName;
  final bool isFresh;
  final double confidence;

  PredictionResult({
    required this.label,
    required this.fruitName,
    required this.isFresh,
    required this.confidence,
  });

  static String extractFruitName(String label) {
    final name = label
        .replaceAll('fresh_', '')
        .replaceAll('rotten_', '');
    return name[0].toUpperCase() + name.substring(1);
  }
}