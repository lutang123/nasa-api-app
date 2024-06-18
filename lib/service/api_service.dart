// / api_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_api_app/model/asteroid.dart';

class ApiService {
  Future<List<Asteroid>> fetchAsteroids() async {
    if (kDebugMode) {
      // Use mock data in debug mode
      return _generateMockData();
    } else {
      final response = await _getWithRetry(Uri.parse('https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=YOUR_API_KEY'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> nearObjects = data['near_earth_objects'];

        return nearObjects.map((json) => Asteroid.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load asteroids');
      }
    }
  }

  Future<http.Response> _getWithRetry(Uri url, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 429) {
        final int waitTime = (pow(2, attempt) * 1000).toInt();
        print('Rate limit exceeded. Waiting for ${waitTime / 1000} seconds.');
        await Future.delayed(Duration(milliseconds: waitTime));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
      attempt++;
    }
    throw Exception('Exceeded retry limit');
  }

  List<Asteroid> _generateMockData() {
    final random = Random();
    return List.generate(10, (index) {
      return Asteroid(
        name: 'Asteroid ${index + 1}',
        isHazardous: random.nextBool(),
      );
    });
  }
}

