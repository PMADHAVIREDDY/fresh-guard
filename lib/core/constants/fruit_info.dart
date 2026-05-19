class FruitInfo {
  final String storage;
  final String temperature;
  final String shelfLife;
  final String tip;

  const FruitInfo({
    required this.storage,
    required this.temperature,
    required this.shelfLife,
    required this.tip,
  });
}

const Map<String, FruitInfo> fruitDatabase = {
  'apple': FruitInfo(
    storage: '🧊 Refrigerator',
    temperature: '0°C – 4°C',
    shelfLife: '4–6 weeks',
    tip: 'Keep away from other fruits. Apples emit ethylene gas.',
  ),
  'banana': FruitInfo(
    storage: '🏠 Room Temperature',
    temperature: '13°C – 15°C',
    shelfLife: '3–5 days',
    tip: 'Never refrigerate unripe bananas. Separate from bunch to slow ripening.',
  ),
  'orange': FruitInfo(
    storage: '🧊 Refrigerator or Cool Area',
    temperature: '4°C – 8°C',
    shelfLife: '2–3 weeks',
    tip: 'Store in mesh bag for air circulation. Keep away from direct sunlight.',
  ),
};