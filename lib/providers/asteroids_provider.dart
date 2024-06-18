// asteroid_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa_api_app/model/asteroid.dart';
import 'package:nasa_api_app/service/api_service.dart';

final asteroidProvider =
    StateNotifierProvider<AsteroidNotifier, List<Asteroid>>((ref) {
  return AsteroidNotifier();
});

class AsteroidNotifier extends StateNotifier<List<Asteroid>> {
  AsteroidNotifier() : super([]);

  Future<void> fetchAsteroids() async {
    final asteroids = await ApiService().fetchAsteroids();
    state = asteroids;
  }

  void toggleChecked(Asteroid asteroid) {
    state = state
        .map((a) => a == asteroid ? a.copyWith(checked: !a.checked) : a)
        .toList();
  }
}
