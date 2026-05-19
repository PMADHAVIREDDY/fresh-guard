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
    // Handles: freshapple, rottenapple, freshbanana,
    //          rottenbanana, freshorange, rottenorange
    String name = label
        .replaceAll('fresh', '')
        .replaceAll('rotten', '')
        .replaceAll('_', '');
    return name[0].toUpperCase() + name.substring(1);
  }
}