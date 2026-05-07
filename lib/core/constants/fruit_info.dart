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
    tip: 'Keep away from other fruits. Apples emit ethylene gas that ripens nearby produce faster.',
  ),
  'banana': FruitInfo(
    storage: '🏠 Room Temperature',
    temperature: '13°C – 15°C',
    shelfLife: '3–5 days',
    tip: 'Never refrigerate unripe bananas. Separate from bunch to slow ripening.',
  ),
};