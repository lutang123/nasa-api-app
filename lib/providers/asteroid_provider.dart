// asteroid_provider.dart
import 'package:flutter/material.dart';
import 'package:nasa_api_app/model/asteroid.dart';
import 'package:nasa_api_app/service/api_service.dart';

class AsteroidProvider with ChangeNotifier {
  List<Asteroid> _asteroids = [];
  List<Asteroid> get asteroids => _asteroids;

  List<Asteroid> get checkedAsteroids =>
      _asteroids.where((asteroid) => asteroid.checked).toList();

  Future<void> fetchAsteroids() async {
    _asteroids = await ApiService().fetchAsteroids();
    notifyListeners();
  }

  void toggleChecked(Asteroid asteroid) {
    int index = _asteroids.indexOf(asteroid);
    if (index != -1) {
      _asteroids[index] =
          _asteroids[index].copyWith(checked: !_asteroids[index].checked);
      notifyListeners();
    }
  }
}
