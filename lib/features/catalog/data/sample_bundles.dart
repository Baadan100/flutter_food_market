import '../domain/bundle.dart';

final List<Bundle> kSampleBundles = [
  Bundle(
    id: 'mix_family_4',
    imageAssetPath: 'assets/images/products/sea_bream.jpg',
    priceCents: 12000,
    peopleCount: 4,
    includedProductIds: const ['salmon', 'shrimp', 'mackerel'],
  ),
  Bundle(
    id: 'mix_party_8',
    imageAssetPath: 'assets/images/products/sea_bass.jpg',
    priceCents: 22000,
    peopleCount: 8,
    includedProductIds: const ['salmon', 'tuna', 'crab', 'sardine'],
  ),
];
