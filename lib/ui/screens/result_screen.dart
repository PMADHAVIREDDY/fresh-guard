import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/models/prediction_result.dart';
import '../../core/constants/fruit_info.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;
  final PredictionResult result;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final info = fruitDatabase[result.fruitName.toLowerCase()];
    final color = result.isFresh
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);
    final statusLabel = result.isFresh ? '✅ Fresh' : '⚠️ Rotten';
    final statusMessage = result.isFresh
        ? 'This fruit looks good to eat!'
        : 'This fruit may have gone bad.';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    result.fruitName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    statusMessage,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Confidence',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${(result.confidence * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: result.confidence,
                          minHeight: 14,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (info != null) ...[
              const Text(
                'Storage Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.kitchen,
                label: 'Best Storage',
                value: info.storage,
              ),
              _InfoCard(
                icon: Icons.thermostat,
                label: 'Ideal Temperature',
                value: info.temperature,
              ),
              _InfoCard(
                icon: Icons.access_time,
                label: 'Shelf Life',
                value: info.shelfLife,
              ),
              _InfoCard(
                icon: Icons.lightbulb_outline,
                label: 'Pro Tip',
                value: info.tip,
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Check Another Fruit',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}